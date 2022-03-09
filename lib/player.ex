defmodule ExMon.Player do
  @keys [:life, :moves, :name]
  @max_life 100

  @enforce_keys @keys

  defstruct @keys

  def build(name, move_rnd, move_avg, move_heal) do
    %__MODULE__{
      life: @max_life,
      moves: %{
        move_avg: move_avg,
        move_heal: move_heal,
        move_rnd: move_rnd,
      },
      name: name
    }
  end
end
