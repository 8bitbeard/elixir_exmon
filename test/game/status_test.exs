defmodule ExMon.Game.StatusTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Status

  describe "print_round_message/1" do
    test "returns a message informing the game has started, when passing a map with status started" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player)

      info = Game.info()

      messages =
        capture_io(fn ->
          assert Status.print_round_message(info) == :ok
        end)

      assert messages =~ "===== The game has started! ====="
    end

    test "returns a message informing the player turn" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player)
      ExMon.make_move(:chute)
      info = Game.info()

      messages =
        capture_io(fn ->
          assert Status.print_round_message(info) == :ok
        end)

      assert messages =~ "===== It's player turn ====="
    end

    test "returns a message informing the game is over" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player)

       new_state = %{
         computer: %Player{
           life: 0,
           moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
           name: "Machine"
         },
         player: %Player{
           life: 100,
           moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
           name: "TestUser"
         },
         status: :started,
         turn: :player
       }

       Game.update(new_state)

      info = Game.info()

      messages =
        capture_io(fn ->
          assert Status.print_round_message(info) == :ok
        end)

      assert messages =~ "===== The game is over! ====="
    end
  end

  describe "print_wrong_move_message/1" do
    test "prints the wrong move message when an invalid move is informed" do
      messages =
        capture_io(fn ->
          assert Status.print_wrong_move_message(:invalid) == :ok
        end)

      assert messages =~ "===== Invalid move: invalid ====="
    end
  end

  describe "print_move_message/1" do
    test "prints the player attack message" do
      messages =
        capture_io(fn ->
          assert Status.print_move_message(:computer, :attack, 15) == :ok
        end)

      assert messages =~ "===== The Player attacked the computer dealing 15 damage! ====="
    end

    test "prints the computer attack message" do
      messages =
        capture_io(fn ->
          assert Status.print_move_message(:player, :attack, 15) == :ok
        end)

      assert messages =~ "===== The Computer attacked the player dealing 15 damage! ====="
    end

    test "prints the healing message" do
      messages =
        capture_io(fn ->
          assert Status.print_move_message(:player, :heal, 15) == :ok
        end)

      assert messages =~ "===== The player healed himself to 15 lifepoints ====="
    end
  end
end
