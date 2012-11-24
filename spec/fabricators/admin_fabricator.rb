Fabricator(:admin) do
  email { sequence(:email) { |i| "admin#{i}@example.com" } }
  password "qwerty"
  password_confirmation "qwerty"
end
