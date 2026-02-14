# OSVVM-CI Template

This repository demonstrates a simple **VHDL project** with **OSVVM** (Open Source VHDL Verification Methodology) testbench, including **simple and randomized tests** for an example combinatorial design. It is integrated with **GitHub Actions** for automated simulation using ModelSim and test reporting using JUnit.

---

## Repository Structure

```bash
|
├── .github/workflows/      # GitHub Actions CI workflows
│   └── vhdl-ci.yml         # CI workflow definition
├── sim/                     # Simulation build scripts and OSVVM setup
│   ├── build.pro            # Compile RTL
│   ├── RunAllTests.pro      # Compile and run all tests
│   ├── run_sim.tcl          # Main simulation script
│   └── setup_osvvm.tcl      # Setup OSVVM libraries
├── src/                     # RTL source code
│   └── example.vhd          # Simple combinatorial logic example
├── tb/                      # Testbench source files
│   ├── TestCtrl_e.vhd       # Test controller entity
│   ├── example_tb.vhd       # Test harness
│   ├── example_tb_SimpleTest.vhd  # Deterministic test
│   └── example_tb_RandomTest.vhd  # Randomized test
├── .gitignore
└── LICENSE
```

---

## Features

* **Combinational RTL example** with AND/OR logic.
* **OSVVM-based testbenches**:

  * Simple deterministic test.
  * Randomized test using OSVVM randomization and barriers.
* **GitHub Actions CI**:

  * Installs OSVVM libraries and ModelSim.
  * Builds and simulates all tests.
  * Parses XML results and fails CI on any errors, failures, or skipped tests.

---

## Prerequisites

* GitHub Actions automatically handles OSVVM, ModelSim, and Tcl/Tdom setup.
* Ubuntu (for CI) or any Linux/macOS/Windows environment with **ModelSim/QuestaSim**.
* **Tcl/Tdom** package installed for XML result checking.

---

## Usage

### Run locally

In ModelSim TCL console run the following commands

```bash
# Setup OSVVM (assuming OSVVM installed at $HOME/OsvvmLibraries)
source sim/setup_osvvm.tcl

# Run simulation
source sim/run_sim.tcl
```

---

### Add your own RTL and tests

1. Add RTL files to `src/`.
2. Add test controllers or harness in `tb/`.
3. Update `sim/build.pro` and `sim/RunAllTests.pro` to include your new files.
4. Run simulation locally or via CI.

---

## CI Workflow

* Triggered on pull requests to `main`.
* Uses cached **OSVVM libraries** and **ModelSim installation** for faster builds.
* Marks CI **FAILED** (via **JUnit Framework**) if any errors, failures, or skipped tests are detected.

---

## References

* [OSVVM GitHub](https://github.com/osvvm/OsvvmLibraries)
* [ModelSim User Guide](https://www.intel.com/content/www/us/en/programmable/quartushelp/20.1/mergedProjects/modelsim.html)
* [JUnit Framework](https://github.com/junit-team/junit-framework)
