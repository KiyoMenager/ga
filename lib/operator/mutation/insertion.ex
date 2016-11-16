defmodule Ga.Operator.Mutation.Insertion do
	@behaviour Ga.Operator

	@doc """
  Implements the Ga.Operator behaviour.

  """
  @spec get_callback() :: Ga.Operator.callback
	def get_callback(_opts \\ []), do: &call/3

	@doc """
	Inserts a node of the genome located at `fst_pos` to `sec_pos`.

	## Examples
			iex> Ga.Operator.Mutation.Insertion.call([0, 1, 2, 3, 4], 0, 4)
			[1, 2, 3, 4, 0]
			iex> Ga.Operator.Mutation.Insertion.call([0, 1, 2, 3, 4], 4, 0)
			[4, 0, 1, 2, 3]
			iex> Ga.Operator.Mutation.Insertion.call([0, 1, 2, 3, 4], 1, 1)
			[0, 1, 2, 3, 4]
			iex> Ga.Operator.Mutation.Insertion.call([0, 1, 2, 3, 4], -1, 3)
			[0, 1, 2, 3, 4]
			iex> Ga.Operator.Mutation.Insertion.call([0, 1, 2, 3, 4], 2, 6)
			[0, 1, 3, 4, 2]

	"""
	@spec call(list(), non_neg_integer, non_neg_integer) :: list()

	def call(genome,     pos,     pos), do: genome
	def call(genome, fst_pos, sec_pos) when sec_pos < fst_pos do
		gene = genome |> Enum.at(fst_pos)
		genome
		|> List.insert_at(sec_pos, gene)
		|> List.delete_at(fst_pos + 1)
	end
	def call(genome, fst_pos, sec_pos) do
		gene = genome |> Enum.at(fst_pos)
		genome
		|> List.insert_at(sec_pos + 1, gene)
		|> List.delete_at(fst_pos)
	end
end
