require 'test_helper'

class Queries::UserQueryTest < ActiveSupport::TestCase
  test 'fetching user attributes' do
    location = FactoryBot.create(:location)
    organization = FactoryBot.create(:organization)
    user = FactoryBot.create(:user, :with_mail,
                                    locations: [location],
                                    default_location: location,
                                    organizations: [organization],
                                    default_organization: organization,
                                    locale: 'en',
                                    timezone: 'Berlin')

    query = <<-GRAPHQL
      query (
        $id: String!
      ) {
        user(id: $id) {
          id
          createdAt
          updatedAt
          login
          admin
          mail
          firstname
          lastname
          fullname
          locale
          timezone
          description
          lastLoginOn
          defaultLocation {
            id
          }
          defaultOrganization {
            id
          }
        }
      }
    GRAPHQL

    user_global_id = Foreman::GlobalId.for(user)
    variables = { id: user_global_id }
    context = { current_user: FactoryBot.create(:user, :admin) }

    result = ForemanGraphqlSchema.execute(query, variables: variables, context: context)
    expected = {
      'id' => user_global_id,
      'createdAt' => user.created_at.utc.iso8601,
      'updatedAt' => user.updated_at.utc.iso8601,
      'login' => user.login,
      'admin' => user.admin,
      'mail' => user.mail,
      'firstname' => user.firstname,
      'lastname' => user.lastname,
      'fullname' => user.fullname,
      'locale' => user.locale,
      'timezone' => user.timezone,
      'description' => user.description,
      'lastLoginOn' => user.last_login_on&.utc&.iso8601,
      'defaultLocation' => {
        'id' => Foreman::GlobalId.for(user.default_location)
      },
      'defaultOrganization' => {
        'id' => Foreman::GlobalId.for(user.default_organization)
      }
    }

    assert_empty result['errors']
    assert_equal expected, result['data']['user']
  end
end