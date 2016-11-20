defmodule Ga.Operator.LocalOptimisation do
  @moduledoc """
  """

  alias Ga.Operator

  @doc """
  Returns an optimisation operator from the given `modules`.
  Because optimisations aim to maximize a criterion, a criterion
  Note: Currently the only suported selection's rate is the default.

  ## Example
      iex> op = Ga.Operator.LocalOptimisation.init([&(&1 * 2)])
      iex> op.(2)
      4
  """
  @spec get_callback() :: Operator.t
  @spec get_callback(list(module)) :: Operator.t

  def get_callback(opts \\ []) do
    modules           = Keyword.get(opts, :modules, [])
    criterion_callback = Keyword.get(opts, :criterion_callback, [])

    modules
    |> Enum.take_random(1)
    |> List.first
    |> optimisation_callback(criterion_callback)
  end

  def optimisation_callback(   nil,                  _), do: nil
  def optimisation_callback(module, criterion_callback) do
    fn genome -> module.run(genome, criterion_callback) end
  end

end
