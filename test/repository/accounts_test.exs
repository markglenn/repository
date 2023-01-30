defmodule Repository.AccountsTest do
  use Repository.DataCase

  alias Repository.Accounts

  describe "organizations" do
    alias Repository.Accounts.Organization

    import Repository.AccountsFixtures

    @invalid_attrs %{archived_at: nil, name: nil}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Accounts.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Accounts.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{archived_at: ~N[2023-01-29 22:20:00], name: "some name"}

      assert {:ok, %Organization{} = organization} = Accounts.create_organization(valid_attrs)
      assert organization.archived_at == ~N[2023-01-29 22:20:00]
      assert organization.name == "some name"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      update_attrs = %{archived_at: ~N[2023-01-30 22:20:00], name: "some updated name"}

      assert {:ok, %Organization{} = organization} = Accounts.update_organization(organization, update_attrs)
      assert organization.archived_at == ~N[2023-01-30 22:20:00]
      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_organization(organization, @invalid_attrs)
      assert organization == Accounts.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Accounts.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organization(organization)
    end
  end
end
