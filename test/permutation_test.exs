defmodule PermutationTest do
  use ExUnit.Case, async: true
  doctest Permutation

  @permutation [1, 2, 3, 4]

  test "Permutation.map returns [] if given permutation []" do
    func = fn edge_x, edge_y -> edge_x + edge_y end
    assert Permutation.edge_map([], func) == []
  end

  test "Permutation.map returns [] if given permutation [1]" do
    func = fn edge_x, edge_y -> edge_x + edge_y end

    single_elem = 3
    permutation = [single_elem]
    expected    = [func.(single_elem, single_elem)]

    assert Permutation.edge_map(permutation, func) == expected
  end
end
