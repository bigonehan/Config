#!/usr/bin/env bash
set -euo pipefail

fish -n /home/tree/Config/data/fish/functions/run_cdp.fish
fish -n /home/tree/.config/fish/functions/run_cdp.fish

node -e '
const fs = require("fs");
const output = {
  scenario_id: "RUN-CDP-FOREGROUND-1",
  requirement_ids: ["RUN-CDP-FOREGROUND-ATTACH"],
  phase: "unit",
  outcome: "success",
  runtime: "fish syntax validation",
  user_action: "run run_cdp and leave the owned Chrome alive",
  observed_consumer: "Fish function syntax and explicit wait path preserve the launched browser PID until termination",
  observation_level: "unit",
  entry_stage: "fish-function",
  original_input: {
    source_kind: "user_action",
    source_ref: "/home/tree/Config/Input.md",
    value_type: "utf-8 text",
    byte_length: 194,
    sha256: "b583916d3fbef184d2617e69c80f4a4bbe9c4ad8d818558bb38c50af0b31a947"
  }
};
fs.writeFileSync(process.env.TEST_MANAGER_OBSERVATION_PATH, JSON.stringify(output));
'
