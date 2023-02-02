defmodule Repository.FulfillmentTest do
  use Repository.DataCase

  alias Repository.Fulfillment

  describe "orders" do
    alias Repository.Fulfillment.Order

    import Repository.FulfillmentFixtures

    @invalid_attrs %{archived_at: nil, fulfilled_at: nil, reference_id: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Fulfillment.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Fulfillment.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{archived_at: ~N[2023-02-01 00:12:00], fulfilled_at: ~N[2023-02-01 00:12:00], reference_id: "some reference_id"}

      assert {:ok, %Order{} = order} = Fulfillment.create_order(valid_attrs)
      assert order.archived_at == ~N[2023-02-01 00:12:00]
      assert order.fulfilled_at == ~N[2023-02-01 00:12:00]
      assert order.reference_id == "some reference_id"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fulfillment.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{archived_at: ~N[2023-02-02 00:12:00], fulfilled_at: ~N[2023-02-02 00:12:00], reference_id: "some updated reference_id"}

      assert {:ok, %Order{} = order} = Fulfillment.update_order(order, update_attrs)
      assert order.archived_at == ~N[2023-02-02 00:12:00]
      assert order.fulfilled_at == ~N[2023-02-02 00:12:00]
      assert order.reference_id == "some updated reference_id"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Fulfillment.update_order(order, @invalid_attrs)
      assert order == Fulfillment.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Fulfillment.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Fulfillment.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Fulfillment.change_order(order)
    end
  end

  describe "order_lines" do
    alias Repository.Fulfillment.OrderLine

    import Repository.FulfillmentFixtures

    @invalid_attrs %{quantity: nil, reference_id: nil}

    test "list_order_lines/0 returns all order_lines" do
      order_line = order_line_fixture()
      assert Fulfillment.list_order_lines() == [order_line]
    end

    test "get_order_line!/1 returns the order_line with given id" do
      order_line = order_line_fixture()
      assert Fulfillment.get_order_line!(order_line.id) == order_line
    end

    test "create_order_line/1 with valid data creates a order_line" do
      valid_attrs = %{quantity: "120.5", reference_id: "some reference_id"}

      assert {:ok, %OrderLine{} = order_line} = Fulfillment.create_order_line(valid_attrs)
      assert order_line.quantity == Decimal.new("120.5")
      assert order_line.reference_id == "some reference_id"
    end

    test "create_order_line/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fulfillment.create_order_line(@invalid_attrs)
    end

    test "update_order_line/2 with valid data updates the order_line" do
      order_line = order_line_fixture()
      update_attrs = %{quantity: "456.7", reference_id: "some updated reference_id"}

      assert {:ok, %OrderLine{} = order_line} = Fulfillment.update_order_line(order_line, update_attrs)
      assert order_line.quantity == Decimal.new("456.7")
      assert order_line.reference_id == "some updated reference_id"
    end

    test "update_order_line/2 with invalid data returns error changeset" do
      order_line = order_line_fixture()
      assert {:error, %Ecto.Changeset{}} = Fulfillment.update_order_line(order_line, @invalid_attrs)
      assert order_line == Fulfillment.get_order_line!(order_line.id)
    end

    test "delete_order_line/1 deletes the order_line" do
      order_line = order_line_fixture()
      assert {:ok, %OrderLine{}} = Fulfillment.delete_order_line(order_line)
      assert_raise Ecto.NoResultsError, fn -> Fulfillment.get_order_line!(order_line.id) end
    end

    test "change_order_line/1 returns a order_line changeset" do
      order_line = order_line_fixture()
      assert %Ecto.Changeset{} = Fulfillment.change_order_line(order_line)
    end
  end
end
