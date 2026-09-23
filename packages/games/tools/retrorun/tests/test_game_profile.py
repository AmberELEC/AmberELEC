"""Run with python3 -m unittest discover -s packages/games/tools/retrorun/tests."""
import runpy
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

PACKAGE = Path(__file__).resolve().parents[1]
SYNC = PACKAGE / "retrorun-config-sync"
KEY = "flycast2021le_game_profile"
ROM = 'Soul Calibur (USA)[DCCM].cdi'


class GameProfileTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.dist = self.root / "distribution.conf"
        self.config = self.root / "retrorun.cfg"
        self.defaults = self.root / "defaults.cfg"
        self.defaults.write_text(f"retrorun_{KEY} = best_performance\n")
        self.config.write_text(f"retrorun_{KEY} = disabled\nkeep_me = yes\n")

    def sync(self, settings, core="flycast2021le", rom=ROM):
        self.dist.write_text(settings)
        subprocess.run([
            sys.executable, str(SYNC), "--distribution", str(self.dist),
            "--config", str(self.config), "--defaults", str(self.defaults),
            "--merge-defaults", "--platform", "dreamcast", "--rom", rom,
            "--core", core,
        ], check=True)
        data = runpy.run_path(str(SYNC))["read_settings"](
            self.config.read_text().splitlines())
        self.assertEqual(data["keep_me"], "yes")
        self.assertEqual(self.config.read_text().count(f"retrorun_{KEY} ="), 1)
        return data[f"retrorun_{KEY}"]

    def test_choices_and_default(self):
        for choice in ("best_performance", "best_validated", "disabled"):
            with self.subTest(choice=choice):
                self.assertEqual(self.sync(f"global.{KEY}={choice}\n"), choice)
        self.assertEqual(self.sync(""), "best_performance")
        self.assertEqual(self.sync(f"global.{KEY}=invalid\n"), "best_performance")

    def test_game_system_global_precedence_and_auto(self):
        base = f"global.{KEY}=disabled\ndreamcast.{KEY}=best_validated\n"
        self.assertEqual(self.sync(base), "best_validated")
        game = f'dreamcast["{ROM}"].{KEY}='
        self.assertEqual(self.sync(base + game + "best_performance\n"), "best_performance")
        self.assertEqual(self.sync(base + game + "auto\n"), "best_validated")
        self.assertEqual(self.sync(f"global.{KEY}=disabled\ndreamcast.{KEY}=auto\n"), "disabled")

    def test_next_game_does_not_keep_previous_override(self):
        settings = f'global.{KEY}=best_performance\ndreamcast["{ROM}"].{KEY}=disabled\n'
        self.assertEqual(self.sync(settings), "disabled")
        self.assertEqual(self.sync(settings, rom="Other Game.cdi"), "best_performance")

    def test_other_cores_do_not_change_profile(self):
        for core in ("flycast", "flycast2021", "mgba", ""):
            with self.subTest(core=core):
                self.assertEqual(self.sync(f"global.{KEY}=best_validated\n", core), "disabled")


if __name__ == "__main__":
    unittest.main()
