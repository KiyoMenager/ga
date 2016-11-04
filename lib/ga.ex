defmodule Ga do

  @stop_conditions 10

  @doc """
  Runs the genetical algorithm.

  `encoded_sol` holds the encoded solution and `distances_matrix` holds the
  precomputed distances. see `Problem` and `DistanceMatrix`.

  """
  @spec run(permutation, DistanceMatrix.t) :: encoded

  def run(permutation, distances_matrix) do
    case permutation |> ga(distances_matrix) do
      {:halt, permutation} -> permutation
      {:cont, permutation} -> permutation |> ga(distances_matrix)
    end
  end

  def ga(encoded_sol, distances_matrix) do

  end
end
