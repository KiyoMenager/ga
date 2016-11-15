defmodule Ga.Operator.Recombination do
  @moduledoc """
  """

  @doc """
  Returns a recombination operator picked from the list of `dependencies`.
  The dependencies must implement the `OperatorBehaviour`.

  ## Example
  
      iex> op = Ga.Operator.Recombination.init([Ga.Operator.Erx])
      iex> recombined = op.([[1, 2, 3, 4], [1, 2, 3, 4]])
      iex> length(recombined)
      4

  """

  def init(dependencies, opts \\ []) do
    module = dependencies |> Enum.take_random(1) |> List.first
    module.run_callback
  end
end
