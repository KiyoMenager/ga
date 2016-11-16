defmodule Ga.Operator.Erx.Hood do

  alias Permutation

  @typedoc """
    A data structure to hold the neightbor list of several paths.

    Parent 1: A B F E D G C
    Parent 2: G F A B C D E

    Generate Neighbor List:

    A: B C F
    B: A F C
    C: A G B D
    D: E G C E
    E: F D G
    F: B E G A
    G: D C E F
  """
  @type t :: %{CGa.Hood.t => %MapSet{}}
  @type element :: any

  @spec new([[element]]) :: t
  def new(graphs) do
    graphs
    |> Enum.reduce(%{}, &generate_hoods(&2, &1))
  end

  @spec generate_hoods(t, [element]) :: t
  defp generate_hoods(hoods, nodes) do
    nodes
    |> Permutation.edge_reduce(hoods, &(&3 |> update_hoods(&1, &2)))
  end

  @spec update_hoods(t, element, element) :: t
  defp update_hoods(hoods, current, next) do
    hoods
    |> Map.update(current, MapSet.new([next]),    &(&1 |> MapSet.put(next)))
    |> Map.update(next,    MapSet.new([current]), &(&1 |> MapSet.put(current)))
  end

  @spec remove_from_neighbors(t, element) :: t
  def remove_from_neighbors(hoods, node) do
    hoods
    |> Enum.reduce(%{}, fn ({n, neighbors}, map) ->
        Map.put(map, n, neighbors |> MapSet.delete(node))
      end)
  end

  @spec take_random_node(t) :: element
  def take_random_node(hoods) do
    hoods
    |> Map.keys
    |> Enum.take_random(1)
    |> List.first
  end

  @spec get_neighbors_and_delete(t, element) :: {t, [element], integer}
  def get_neighbors_and_delete(hoods, node) do
    neighbors = hoods     |> get_neighbors_set(node)
    size      = neighbors |> MapSet.size

    {hoods |> delete(node), neighbors |> Enum.to_list, size}
  end

  @spec delete(t, element) :: t
  def delete(hoods, node) do
    hoods |> Map.delete(node)
  end

  @spec get_neighbors_set(t, element) :: MapSet.t
  def get_neighbors_set(hoods, node) do
    hoods |> Map.fetch!(node)
  end

  @spec get_neighbors_size(t, element) :: integer
  def get_neighbors_size(hoods, node) do
    hoods |> Map.fetch!(node) |> MapSet.size
  end

  @spec smallests(t, [element]) :: [CGa.Node.t]
  def smallests(hoods, [node|nodes]) do
    nodes
    |> Enum.reduce([node], fn next, [smallest|_] = smallests ->
      s_size = hoods |> get_neighbors_size(smallest)
      n_size = hoods |> get_neighbors_size(next)
      cond do
        n_size == s_size -> [next|smallests]
        n_size <  s_size -> [next]
        true -> smallests
      end
    end)
  end
end
