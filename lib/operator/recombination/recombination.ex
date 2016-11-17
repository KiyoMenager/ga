defmodule Ga.Operator.Recombination do
  @moduledoc """
  """
  @behaviour Ga.Operator

  @doc """
  Returns a recombination operator picked from the list of `dependencies`.
  The dependencies must implement the `OperatorBehaviour`.

  ## Example

      iex> op = Ga.Operator.Recombination.get_callback(modules: [Ga.Operator.Erx])
      iex> recombined = op.([[1, 2, 3, 4], [1, 2, 3, 4]])
      iex> length(recombined)
      4

      iex> Ga.Operator.Recombination.get_callback(modules: [])
      nil

  """

  def get_callback(opts \\ []) do
    modules = Keyword.get(opts, :modules, [])
    modules
    |> Enum.take_random(1)
    |> List.first
    |> recombination_callback
  end

  def recombination_callback(module) when is_nil(module), do: nil
  def recombination_callback(module), do: module.get_callback
end
