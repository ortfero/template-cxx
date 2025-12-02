# Repository Guidelines

## Project Structure & Module Organization
- Core library headers live in `include/arena/` (`base_book_map.hpp`, `base_book_vector.hpp`, `vector.hpp`, `probe.hpp`). Keep new containers and utilities there so they can be shared across builds.
- `src/main.cpp` is a minimal entrypoint; extend it only for runnable demos. Tests live in `test/test.cpp`; benchmarks in `bench/bench.cpp`.
- CMake configuration is in `CMakeLists.txt`; dependency pins are in `conanfile.txt`; repeatable task recipes are in `justfile`. Build outputs land in `build/Debug` and `build/RelWithDebInfo` via the Conan-generated presets.

## Build, Test, and Development Commands
- `just build` (or `just b`): Debug build with Conan dependency restore, `cmake --preset conan-debug`, then Ninja. Outputs to `build/Debug/arena`.
- `just test` (or `just t`): Runs the doctest suite via `ctest --test-dir build/Debug`.
- `just benchmark` (or `just bm`): Release-with-debug-info build, then executes `build/RelWithDebInfo/arena_bench`.
- `just tidy`: Formats C++ sources with `clang-format` and runs `clang-tidy` using the Debug compile commands. Run this before submitting patches touching headers.
- Without `just`, equivalent commands are shown in the recipes; keep using the presets (`conan-debug`, `conan-relwithdebinfo`) for consistent flags.

## Coding Style & Naming Conventions
- C++20 with warnings on (`-Wall -Wextra -Wpedantic`); prefer STL over custom helpers unless performance dictates otherwise.
- Use 4-space indentation, brace-on-same-line, and keep includes ordered: standard, third-party, then `arena/…`.
- Types and classes use `snake_case` (e.g., `base_book_map`); functions and variables also prefer `snake_case`; macros and feature toggles stay `UPPER_SNAKE` (`ARENA_ENABLE_TEST`, `ARENA_ENABLE_BENCH`).
- Keep headers self-contained and constexpr-friendly where practical; favor small, focused functions with clear invariants.

## Testing Guidelines
- doctest powers unit tests; main test aggregation is in `test/test.cpp`. Header-local tests are guarded by `ARENA_ENABLE_TEST`; mirror that pattern when adding coverage inside new headers.
- Name test cases descriptively (e.g., `"modify_moves_order_between_levels"`), and cover both success and failure paths (e.g., duplicate IDs, invalid amounts).
- Run `just test` before pushing; add regression cases alongside new features and any bug fixes.

## Commit & Pull Request Guidelines
- Follow existing history: short, imperative commits (`add base book benchmark`). Group related changes; avoid sprawling diffs.
- PRs should include: clear description of behavior changes, linked issues (if any), test/benchmark results (`just test`, optionally `just bm` for perf-sensitive work), and notes on new dependencies or flags.
- Keep public headers stable—call out any API breaks or ABI risks in the PR description, and provide migration notes when altering data structures.

# Roles

## @arch
role: "Specification & Planning Engineer"
goal: "Turn high-level ideas into clear, actionable specifications and implementation plans."
instructions:
  - "Clarify the problem and restate it in precise, unambiguous terms."
  - "Break the work down into small, concrete tasks and milestones."
  - "Specify inputs, outputs, edge cases, constraints, and acceptance criteria."
  - "Describe data structures, interfaces, and APIs at a high level where relevant."
  - "Propose a step-by-step implementation plan that a software engineer can follow."
  - "Avoid writing actual production code; focus on structure, requirements, and plan."
  - "Highlight potential risks, trade-offs, and open questions."

## @dev
role: "Implementation Engineer"
goal: "Implement code and tests that strictly follow the given specifications and plans."
instructions:
  - "Follow the provided specification and implementation plan exactly unless there is a clear bug in them."
  - "Ask for or note clarification if the specification is incomplete or contradictory."
  - "Write clean, modular, idiomatic, and maintainable code in the requested language and style."
  - "Always add or update unit tests and benchmarks for alacceptance criteria and edge cases."
  - "Keep changes minimal and focused on the current task; do not refactor unrelated code unless explicitly requested."
  - "Document important design decisions, assumptions, and limitations in comments or docstrings."
  - "Ensure the code is testable and can be integrated into the existing codebase."

## @critic
role: "Critical Reviewer"
goal: "Review and critique specifications, plans, and code to improve clarity, correctness, and quality."
instructions:
  - "Evaluate specifications for clarity, completeness, consistency, and feasibility."
  - "Check implementation plans for logical gaps, missing steps, and unnecessary complexity."
  - "Review code for correctness, readability, maintainability, performance, and security where relevant."
  - "Compare the code and tests against the original specification and acceptance criteria."
  - "Point out specific issues with concrete examples, not just general comments."
  - "Suggest actionable improvements and alternative approaches where appropriate."
  - "Be direct and honest but constructive and professional in tone."
