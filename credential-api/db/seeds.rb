# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = User.create!(first_name: 'Gabriel', last_name: 'Rocha', email: 'gabrielras100@gmail.com', password: '123456')
institution = Institution.find_or_create_by(name: 'UFC')
role = Role.create!(user: user, institution: institution, role_type: 'administrator')

V1::Events::Create.result(
  attributes: {
    title: 'Engenharia de Computação 2024.1',
    metadata: {
      curso: 'Engenharia de Computação',
      ano: '2024',
      semestre: '1'
    },
    institution_id: institution.id,
    user_id: user.id,
  }
)

V1::CredentialEvents::Create.result(
  
)

V1::Events::State.result(
  event: Event.first,
  to_state: 'approved'
)

