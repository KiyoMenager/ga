defmodule Ga.Operator.Mutation.Inversion do
  @behaviour Ga.Operator

  @doc """
  Implements the Ga.Operator behaviour.

  """
  @spec get_callback() :: Ga.Operator.callback

	def get_callback(_opts \\ []), do: &call/3

  @doc """
  Inverses all the nodes of the `genome` located in the interval defined by
  the given `fst_pos` and `sec_pos`

  ## Examples

      iex> Ga.Operator.Mutation.Inversion.call([0, 1, 2, 3, 4], 0, 4)
      [4, 3, 2, 1, 0]
      iex> Ga.Operator.Mutation.Inversion.call([0, 1, 2, 3, 4], 1, 1)
      [0, 1, 2, 3, 4]
      iex> Ga.Operator.Mutation.Inversion.call([0, 1, 2, 3, 4], -1, 3)
      [0, 1, 2, 3, 4]
      iex> Ga.Operator.Mutation.Inversion.call([0, 1, 2, 3, 4], 2, 6)
      [0, 1, 4, 3, 2]

  """
  @spec call(list(), non_neg_integer, non_neg_integer) :: list()

  def call(genome,      pos,      _) when pos < 0, do: genome
  def call(genome,       _,     pos) when pos < 0, do: genome
  def call(genome,     pos,     pos), do: genome
  def call(genome, fst_pos, sec_pos) when sec_pos < fst_pos do
    call(genome, sec_pos, fst_pos)
  end
  def call(genome, fst_pos, sec_pos) do
    genome |> Enum.reverse_slice(fst_pos, (sec_pos + 1) - fst_pos)
  end

end
