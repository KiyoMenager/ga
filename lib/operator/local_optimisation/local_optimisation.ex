defmodule Ga.Operator.LocalOptimisation do
  @moduledoc """
  """

  alias Ga.Operator

  @doc """
  Returns an operator from the given `modules` according to the given `:rate`
  option. If not options is given, the chance for each operator to be selected
  is equal.

  Note: Currently the only suported selection's rate is the default.

  ## Example
      iex> op = Ga.Operator.LocalOptimisation.init([&(&1 * 2)])
      iex> op.(2)
      4
  """
  @spec init(module) :: Operator.t
  @spec init(module, list) :: Operator.t

  def init(dependencies, opts \\ []) do
    module = dependencies |> Enum.take_random(1) |> List.first
    module.run_callback
  end
end
