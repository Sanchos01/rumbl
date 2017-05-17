# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%Rumbl.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Rumbl.Repo
alias Rumbl.Category
alias Rumbl.User
alias Rumbl.Video
# alias Rumbl.Annotation

for category <- ~w(Action Drama Romance Comedy Sci-fi) do
  Repo.get_by(Category, name: category) ||
    Repo.insert!(%Category{name: category})
end

# Adding default user with some video and annotations
if Repo.get_by(User, name: "foobarbaz") do
  IO.puts("Warning: user already exists")
  else
    %{name: name, username: username, password_hash: hash} = User.registration_changeset(%User{},
      %{name: "foobarbaz", username: "foobarbaz123", password: "123 super secret"}).changes
    Repo.insert!(%User{name: name, username: username, password_hash: hash})
    IO.puts("Success: user created")
end
# user_id = Repo.get_by(User, name: "foobarbaz").id
# if Repo.get_by(Video, user_id: user_id, title: title)