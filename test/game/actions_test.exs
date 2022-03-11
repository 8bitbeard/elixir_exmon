defmodule ExMon.Game.ActionsTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions

  describe "attack/1" do
    test "when a valid attack move is passed, performs the attack" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player, :random)
      turn =
        Game.turn()
        |> Atom.to_string()
        |> String.capitalize()

      messages =
        capture_io(fn ->
          assert Actions.attack(:move_avg) == :ok
        end)

      assert messages =~ "===== The #{turn} attacked"
    end
  end

  describe "heal/0" do
    test "when called, heals the current turn player" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player, :random)
      turn = Game.turn()

      messages =
        capture_io(fn ->
          assert Actions.heal == :ok
        end)

      assert messages =~ "===== The #{turn} healed himself to 100 lifepoints ====="
    end
  end

  describe "fetch_move/0" do
    test "returns a move when passing a valid argument" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player, :random)

      response = Actions.fetch_move(:chute)

      expected_response = {:ok, :move_rnd}

      assert response == expected_response
    end
  end
end
