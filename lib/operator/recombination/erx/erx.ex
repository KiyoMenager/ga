defmodule Ga.Operator.Erx do
  @moduledoc """
  The Erx (Edge recombination) operator is a crossover techniques for
  permutation (ordered) chromosomes. It strives to introduce the fewest paths
  possible. The idea here is to use as many existing edges, or
  node-connections, as possible to generate children. Edge Recombination
  typically out performs PMX and Ordered crossover, but usually takes longer
  to compute.

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

  CHILD = Empty Chromosome

  1. X = the first node from a random parent.
  2. While the CHILD chromo isn't full, Loop:
    - Append X to CHILD
    - Remove X from Neighbor Lists

    if X's neighbor list is empty:
      - Z = random node not already in CHILD
    else
      - Determine neighbor of X that has fewest neighbors
      - If there is a tie, randomly choose 1
      - Z = chosen node
      X = Z
  """

  alias Ga.Operator.Erx.Hood

  @behaviour Ga.Operator

  @doc """
  Implementation of the `OperatorBehaviour`.
  """
  @spec run_callback() :: (list -> list)
  def run_callback, do: &run/1

  @doc """
  Applies the edge recombination operator to the given `routes`.
  """
  @spec run(list(list())) :: list()
  def run(routes) do
    routes
    |> Hood.new
    |> recombine(routes)
  end

  defp recombine(hoods, routes) do
    root_parent  = routes |> Enum.take_random(1) |> List.first
    root_node    = root_parent |> List.first
    child_length = length(root_parent)

    [] |> build_child(hoods, root_node, child_length)
  end

  defp build_child(child, _, _, 0), do: child |> Enum.reverse

  defp build_child(child, hoods, node, length) do
    hoods = hoods |> Hood.remove_from_neighbors(node)

    case hoods |> Hood.get_neighbors_and_delete(node) do
      {hoods, _, 0} ->
        next_node = hoods |> Hood.take_random_node
        build_child([node| child], hoods, next_node, length - 1)
      {hoods, neighbors, _} ->
        next_node = hoods |> Hood.smallests(neighbors) |> Enum.take_random(1) |> List.first
        build_child([node| child], hoods, next_node, length - 1)
    end
  end
end
