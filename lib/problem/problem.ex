defmodule Problem do
  @moduledoc """
  """

  alias DistanceMatrix
  alias DistanceMatrix.Localizable
  alias Problem.Decoder

  defstruct [:decoder, :distance_matrix]
  @type t :: %__MODULE__{
    decoder: Decoder,
    distance_matrix: DistanceMatrix.t
  }


  @spec new(list(Localizable.t)) :: t

  def new(tour) do
    %__MODULE__{
      decoder: Decoder.new(tour),
      distance_matrix: DistanceMatrix.create(tour)
    }
  end
end
