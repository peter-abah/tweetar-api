json.partial! 'api/v1/users/user',
              locals: { user: @user, options: { add_token: true } }