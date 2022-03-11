defmodule ExMon.Game.Actions.HealTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions.Heal

  describe "heal_life/1" do
    test "the player should perform an heal over 100 successfully" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player, :player)

      messages =
        capture_io(fn ->
          assert Heal.heal_life(:player) == :ok
        end)

      assert messages =~ "===== The player healed himself to 100 lifepoints ====="
    end

    test "the computer should perform an heal over 100 successfully" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player, :computer)

      messages =
        capture_io(fn ->
          assert Heal.heal_life(:player) == :ok
        end)

      assert messages =~ "===== The player healed himself to 100 lifepoints ====="
    end

    test "should perform an heal under 100 successfully" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player, :random)

      new_state = %{
        computer: %Player{
          life: 85,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Machine"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "TestUser"
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)

      messages =
        capture_io(fn ->
          assert Heal.heal_life(:player) == :ok
        end)

      assert messages =~ "===== The player healed himself to"
    end
  end
end
