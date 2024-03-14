
defmodule BoutiqueInventory do

  defstruct inventory: []

  def new() do
    %BoutiqueInventory{}
  end

  def add_item(inventory, item) do
    %BoutiqueInventory{inventory: [item | inventory.inventory]}
  end

  def add_size(inventory, item_name, size, amount) do
    new_inventory = Enum.map(
      inventory.inventory,
      fn item ->
        if item.name == item_name do
          %{item | quantity_by_size: Map.put(item.quantity_by_size, size, amount)}
        else
          item
        end
      end
    )
    %BoutiqueInventory{inventory: new_inventory}
  end

  def remove_size(inventory, item_name, size) do
    new_inventory = Enum.map(
      inventory.inventory,
      fn item ->
        if item.name == item_name do
          %{item | quantity_by_size: Map.delete(item.quantity_by_size, size)}
        else
          item
        end
      end
    )
    %BoutiqueInventory{inventory: new_inventory}
  end

  def sort_by_price(inventory) do
    Enum.sort_by(
      inventory,
      fn item -> item.price end,
      :asc
    )
  end

  def with_missing_price(inventory) do
    Enum.filter(
      inventory.inventory,
      fn item -> not Map.has_key?(item, :price) end
    )
  end


  def increase_quatity(item, amount) do
    new_quantities_by_size = Map.keys(item.quantity_by_size)
    |> Enum.map(fn key -> {key, Map.get(item.quantity_by_size, key) + amount} end)
    |> Map.new()

    %{item | quantity_by_size: new_quantities_by_size}
  end

  def total_quantity(item) do
    Map.values(item.quantity_by_size)
    |> Enum.sum()
  end

end
