defmodule LocalSearch.Node do

  defstruct [:x, :y]
  @type t :: %__MODULE__{x: float, y: float}

  @doc """
  Creates a new node.
  """
  @spec new(float, float) :: t

  def new(x, y), do: %__MODULE__{x: x, y: y}
end


defimpl DistanceMatrix.Localizable, for: LocalSearch.Node do
  alias LocalSearch.Node

  @doc """
  Calculates the manathan distance between 2 nodes.
  """
  @spec distance(Node.t, Node.t) :: non_neg_integer

  def distance(%Node{x: fst_x, y: fst_y}, %Node{x: sec_x, y: sec_y}) do
    (:erlang.abs(sec_x - fst_x)) + (:erlang.abs(sec_y - fst_y))
  end
end
