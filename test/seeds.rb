require 'fx-auth/models'


DataMapper::Logger.new $stdout, :debug
DataMapper.setup :default, 'sqlite::memory:'
DataMapper.auto_migrate!


AuthFx::UserProfile.create(
    {
        :email       => 'admin@authfx.com',
        :pass_phrase => 'password',

        :roles       => [
            {
                :name => 'admin'
            },
            {
                :name => 'user'
            }
        ]
    }
)
