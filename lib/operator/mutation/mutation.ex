defmodule Ga.Operator.Mutation do
  @moduledoc """
  The mutation operator applies
  The mutation operator consists in applying a list of mutation operations to
  each gene with equal probability.

  """

  @behaviour Ga.Operator

  @typedoc """
  Options used by the get_callback function
  """
  @type options :: [option]

  @typedoc """
  Option values used by the get_callback function
  """
  @type option  ::  {:rate, rate}
                |   {:modules, list(module)}

  @typedoc """
  The mutation rate.
  """
  @type rate    :: Float.t

  @doc """
  Implements the Ga.Operator behaviour.

  Returns a mutation operator callback.

  Accepts the options:
    `:modules`: The list of module defining mutation operator.
    `:rate`: The mutation rate. If not provided the default 0.015 will be used.

  ## Examples


  """
  @spec get_callback(options) :: Ga.Operator.callback

  def get_callback(opts \\ []) do
    mutations     = Keyword.get(opts, :modules, [])
    mutation_rate = Keyword.get(opts, :rate, 0.015)

    fn [first|genome] -> [first|run(genome, mutations, mutation_rate)] end
  end

  @doc """
  Applies a per locus mutation according to the `mutation_rate`.

  For each locus, according to the given `mutation_rate`, a mutation operator
  is randomly picked from the given `mutations` and applied to the given
  `genome`.

  ## Examples

      iex> Ga.Operator.Mutation.run([1, 2, 3, 4], [], 1)
      [1, 2, 3, 4]

      iex> Ga.Operator.Mutation.run([1, 2, 3, 4], [Ga.Operator.Mutation.Insertion], 0)
      [1, 2, 3, 4]

      iex> mutated = Ga.Operator.Mutation.run([1, 2, 3, 4], [Ga.Operator.Mutation.Insertion], 1)
      iex> length(mutated)
      4
  """
  @spec run(list, list(module), rate) :: list

  def run(genome,        [],             _), do: genome
  def run(genome, mutations, mutation_rate) do
    genome_size = length(genome)

    Stream.repeatedly(fn -> select_mutation(mutations, :rand.uniform(), mutation_rate) end)
    |> Stream.scan(genome, &apply_mutation(&1, &2, genome_size - 1))
    |> Enum.take(genome_size + 1)
    |> List.last
  end

  @doc """
  Applies the given mutation operator defined by `module` on the given `genome`.
  `max_idx` is passed to get random positions from interval [0 .. max_idx].

  """
  @spec apply_mutation(module, list, non_neg_integer) :: list

  def apply_mutation(nil,      genome,       _), do: genome
  def apply_mutation(operator, genome, max_idx) do
    fst_pos = round(:rand.uniform() * max_idx)
    sec_pos = round(:rand.uniform() * max_idx)

    operator.(genome, fst_pos, sec_pos)
  end

  # Randomly selects a mutation operator.
  @spec select_mutation(list(module), rate, rate) :: module

  defp select_mutation(_,    rate, mutation_rate) when rate > mutation_rate, do: nil
  defp select_mutation(modules, _,             _) do
    module = modules |> Enum.take_random(1) |> List.first
    module.get_callback
  end
end
