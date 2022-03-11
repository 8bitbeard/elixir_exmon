defmodule ExMon do
  alias ExMon.{Game, Player}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Robotinik"
  @computer_moves [:move_avg, :move_rnd, :move_heal]

  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_avg, move_rnd, move_heal)
  end

  def start_game(player, first_player \\ :random) do
    @computer_name
    |> create_player(:punch, :kick, :heal)
    |> Game.start(player, first_player)

    Status.print_round_message(Game.info())
    handle_first_move(Game.info())
  end

  def make_move(move) do
    Game.info()
    |> Map.get(:status)
    |> handle_status(move)
  end

  defp handle_status(:game_over, _move), do: Status.print_round_message(Game.info())

  defp handle_status(_other, move) do
    move
    |> Actions.fetch_move()
    |> do_move()

    computer_move(Game.info())
  end

  defp do_move({:error, move}), do: Status.print_wrong_move_message(move)
  defp do_move({:ok, move}) do
    case move do
      :move_heal -> Actions.heal()
      move -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end

  defp handle_first_move(%{turn: :computer, status: :started}) do
    {:ok, Enum.random(@computer_moves)}
    |> do_move()
  end

  defp handle_first_move(_), do: :ok

  defp computer_move(%{computer: %Player{life: computer_life}, turn: :computer, status: :continue}) do
    computer_life
    |> handle_computer_movement()
    |> do_move()
  end

  defp computer_move(_), do: :ok

  defp handle_computer_movement(life) do
    case life < 40 do
      true -> {:ok, Enum.random(@computer_moves ++ List.duplicate(:move_heal, 2))}
      _ -> {:ok, Enum.random(@computer_moves)}
    end
  end
end
