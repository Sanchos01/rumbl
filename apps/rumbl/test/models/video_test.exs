defmodule Rumbl.VideoTest do
  use Rumbl.ModelCase, async: true
  alias Rumbl.Video

  @valid_attrs %{description: "some content", title: "some content", url: "http://youtu.be"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Video.changeset(%Video{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Video.changeset(%Video{}, @invalid_attrs)
    refute changeset.valid?
  end
end
