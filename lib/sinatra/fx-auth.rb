require 'fx-auth/models'


module Sinatra

  module FxAuth

    module Helpers

      def authenticated?
        authenticated  = false
        profile, token = token_credentials
        authenticated = profile.authenticate? token if profile         #, request.ip if profile
        log_authentication_failure profile, token unless authenticated #, request.ip unless authenticated
        authenticated
      end


      def authorized? *roles
        authorized     = false
        profile, token = token_credentials
        authorized = profile.authorized? roles if profile
        log_authorization_failure profile, roles unless authorized
        authorized
      end


      private


      def token_credentials
        profile = nil
        token   = request.env['HTTP_X_AUTH_TOKEN']
        unless token.nil?
          passkey = PassKey.first :token => token
          if passkey and passkey.user_profile.in_role? :admin # :admin takes precedence over :user
            profile = passkey.user_profile
          else
            profile = UserProfile.get params[:id]
          end
        end
        return profile, token
      end


      def param_credentials
        return params[:profile][:email], params[:profile][:pass_phrase]
      end


      def valid_params?
        # TODO Handle JSON body as well as FORM encoding
        #  request.body.rewind  # in case someone already read it
        #  profile = JSON.parse request.body.read

        params[:profile] and params[:profile][:email] and params[:profile][:pass_phrase]
      end


      def error_message
        message = env['sinatra.error'].message
        logger.error '### Error: ' + message + ' ###'
        {:error => message}.to_json
      end


      def find_user
        profile = UserProfile.get params[:id]
        raise MissingUserError unless profile
        profile
      end


      def profile_exclusions
        [
            :created_at,
            :updated_at,
            :email_verification_code,
            :pass_phrase,
            :pass_phrase_crypt,
            :pass_phrase_expires_at,
            :sign_on_attempts,
            :locked_until
        ]
      end


      def pass_key_exclusions
        [
            :id,
            :created_at,
            :updated_at,
            :user_profile_id
        ]
      end


      def log_authentication_failure profile, token #, ip_address
        logger.warn '### BEGIN Authentication FAILURE ###'
        if profile
          logger.warn '      Profile: ' + profile.id.to_s
          logger.warn '      Status: ' + profile.status.to_s if profile.status != :online
          if profile.pass_key
            logger.warn '      Token: ' + profile.pass_key.token + ' != Attempted: ' + token if profile.pass_key.token != token
            logger.warn '      Expired: ' + profile.pass_key.expires.to_s + ' < ' + Time.now.to_s if profile.pass_key.expired?
            #logger.warn '      IP: ' + profile.pass_key.ip_address.to_s + ' != Attempted: ' + ip_address if profile.pass_key.ip_address != ip_address
          else
            logger.warn '      PassKey: Missing'
          end
        else
          logger.warn '      Profile: Not Found'
        end
        logger.warn '### END   Authentication FAILURE ###'
      end


      def log_authorization_failure profile, allowed_roles
        logger.warn '### BEGIN Authorization FAILURE ###'
        if profile
          profile_roles = []
          profile.roles.each { |role| profile_roles.push role.name.to_sym }
          logger.warn '      Profile: ' + profile.id.to_s
          logger.warn '      Allowed Roles: ' + allowed_roles.to_s
          logger.warn '      Profile Roles: ' + profile_roles.to_s
        else
          logger.warn '      Profile: Not Found'
        end
        logger.warn '### END   Authorization FAILURE ###'
      end

    end


    def self.registered app
      app.helpers FxAuth::Helpers

      app.enable :logging

      app.set :raise_errors, Proc.new { false }
      app.set :show_exceptions, false


      app.set :auth do |*roles|
        condition do
          unless authenticated? and authorized? *roles
            halt 401 # TODO Return any additional info? Expired session, etc.?
          end
        end
      end


      app.before do
        content_type 'application/json' # TODO Support other representations, XML, etc.
      end


      # Sign Up
      app.post '/profiles/?' do
        halt 422 unless valid_params?

        email, pass_phrase = param_credentials
        profile            = UserProfile.sign_up email, pass_phrase #, request.ip

        if profile.errors.length == 0
          headers "location"     => '/profiles/' + profile.id.to_s,
                  "X-AUTH-TOKEN" => profile.pass_key.token
          body profile.to_json :exclude => profile_exclusions
          status 201

        else
          errs = {:errors => profile.errors.to_h}
          body errs.to_json
          status 412
        end
      end


      # Sign On
      app.post '/profiles/:id/key/?' do
        profile = find_user

        raise InvalidUserError unless valid_params?
        raise LockedUserError.new :locked_until => profile.locked_until if profile.status == :locked

        email, pass_phrase = param_credentials
        pass_key           = profile.sign_on email, pass_phrase #, request.ip

        if pass_key
          headers "location"     => '/profiles/' + profile.id.to_s + '/key',
                  "X-AUTH-TOKEN" => pass_key.token
          body pass_key.to_json :exclude => pass_key_exclusions
          status 201
        end
      end


      # Sign Off
      app.delete '/profiles/:id/key', :auth => [:admin, :user] do
        profile = find_user
        profile.sign_off
      end


      app.get '/profiles/:id', :auth => [:admin, :user] do
        profile = find_user
        profile.to_json :exclude => profile_exclusions
      end


      app.put '/profiles/:id', :auth => [:admin, :user] do
        profile = find_user
        if profile.update params[:profile]
          profile.to_json :exclude => profile_exclusions
        else
          errs = {:errors => profile.errors.to_h}
          body errs.to_json
          status 412
        end
      end


      app.get '/profiles/?', :auth => :admin do
        UserProfile.all.to_json :exclude => profile_exclusions
      end


      app.delete '/profiles/:id', :auth => :admin do
        profile = find_user
        unless profile.destroy
          errs = {:errors => profile.errors.to_h}
          body errs.to_json
          status 412
        end
      end


      app.error InvalidUserError do
        halt 401, error_message
      end


      app.error MissingUserError do
        halt 404, error_message
      end


      app.error DuplicateUserError do
        halt 409, error_message
      end


      app.error LockedUserError do
        halt 423, error_message
      end


      app.error do
        halt 500, error_message
      end

    end

    register FxAuth
  end
end
