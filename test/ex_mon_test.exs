defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}

  describe "create_player/4" do
    test "returns a player struct" do
      response = ExMon.create_player("TestUser", :chute, :soco, :cura)

      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "TestUser"
      }

      assert response == expected_response
    end
  end

  describe "start_game/1" do
    test "when the game is started, returns a message" do
      player = Player.build("TestUser", :chute, :soco, :cura)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "===== The game has started! ====="
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("TestUser", :chute, :soco, :cura)
      ExMon.start_game(player)

      :ok
    end

    test "when the movement is valid, the player and the computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:chute)
        end)

      assert messages =~ "===== The Player attacked the computer dealing"
      assert messages =~ "===== It's computer turn ====="
      assert messages =~ "status: :continue,\n  turn: :computer"
      assert messages =~ "===== It's player turn ====="
      assert messages =~ "status: :continue,\n  turn: :player"
    end

    test "when the movement is heal, the player and the computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:cura)
        end)

      assert messages =~ "===== The player healed himself to 100 lifepoints ====="
      assert messages =~ "===== It's computer turn ====="
      assert messages =~ "status: :continue,\n  turn: :computer"
      assert messages =~ "===== It's player turn ====="
      assert messages =~ "status: :continue,\n  turn: :player"
    end

    test "when the movement is invalid, returns an error message" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:invalid)
        end)

      expected_message = "\n ===== Invalid move: invalid =====\n\n"

      assert messages =~ expected_message
    end

    test "when the game is over, a message is displayed" do
      new_state = %{
        computer: %Player{
          life: 35,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Machine"
        },
        player: %Player{
          life: 0,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "TestUser"
        },
        status: :game_over,
        turn: :player
      }

      Game.update(new_state)

      messages =
        capture_io(fn ->
          ExMon.make_move(:chute)
        end)

      expected_message = "===== The game is over! ====="

      assert messages =~ expected_message
    end
  end
end
