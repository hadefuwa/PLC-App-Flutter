What this app is

A teaching and control companion for the Smart Factory training rig. Version 0 runs entirely on simulated data so it works without any hardware. Later, we can connect it to a real PLC or Raspberry Pi gateway without changing the screens.

Who will use it

Students: run the line, complete worksheets, see live metrics.

Instructors: set up activities, trigger simulated faults, export logs.

Devices to support

Android phones and 7–10 inch tablets.

Works offline. No permissions required except file storage for CSV export.

How it should look and feel

Material Design 3, light and dark themes.

Big tiles, large buttons, simple language.

Color rules:

Green = running/ok.

Amber = warning or paused.

Red = fault or e-stop.

Blue = neutral information.

Icons: play, stop, reset, settings, chart, wrench.

Navigation

Bottom bar with 5 tabs:

Home

Run

I/O

Worksheets

Analytics
Settings is a gear icon in the top right of Home.

Screen by screen
Home

Goal: Quick status and main controls.

Show:

Large status card: Running or Stopped.

Live metrics row: Cycle count, Rejects, FPY percent, Throughput.

Uptime timer.

Buttons: Start, Stop, Reset Faults.

Connection badge: “Simulation mode”.

Behavior:

Start turns the system on in the simulator.

Stop pauses everything safely.

Reset Faults clears any simulated alarms.

Metrics update about 10 times per second.

Success criteria:

From this screen the user can start a batch and see numbers change immediately.

Run

Goal: Choose a recipe and watch production progress.

Show:

Recipe selector:

“Steel/Aluminium/Plastic Sorting” default.

Setpoints:

Conveyor speed slider 0 to 100.

Batch target quantity.

Live counters:

Steel, Aluminium, Plastic, Rejects, Remaining.

Manual jog area:

Conveyor jog on/off.

Test buttons for left paddle, right paddle, plunger.

Behavior:

Changing speed affects how quickly counts increase.

Manual jogs work only when safe (interlocks below).

Interlocks to enforce:

Plunger cannot move while conveyor is running.

No outputs can change if e-stop is active.

Paddles auto-return after a short pulse.

Success criteria:

User can set a target, tap Start on Home, and see progress to target.

I/O (Live)

Goal: Show inputs and outputs like a control panel.

Show a 2x4 or 3x4 grid of tiles:

Inputs (read only): First Gate, Inductive, Capacitive, Photo Gate, E-Stop, Gantry Home.

Outputs (tappable): Conveyor, Paddle Steel, Paddle Aluminium, Plunger Down, Vacuum, Gantry Step, Gantry Dir.

Each tile:

Label, small icon, colored state light.

Tapping an output opens a confirmation sheet:

“Pulse for 500 ms” or “Latch on/off”.

Behavior:

Refresh every 250 ms.

Disabled state if interlocks block the action.

Tooltip below grid if something is blocked: “Blocked by E-Stop” or “Stop conveyor first”.

Success criteria:

A beginner can see which “bits” are currently on and safely test an output.

Worksheets

Goal: Deliver guided learning activities.

Show:

Scrollable list of 17 worksheet cards. Each card:

Title, short goal sentence, estimated time.

Start button.

When opened:

Simple markdown or embedded page with steps, checkboxes, quiz questions.

“Mark complete” at the end.

Progress:

Store completion ticks locally. Show percentage done.

Examples of worksheet goals:

Data logging basics.

Analytics: calculate throughput and FPY from recent data.

IO-Link intro (content describes concept, still simulated).

Predictive maintenance: interpret a rising reject rate.

Success criteria:

Learner can read, follow steps, tick tasks, and see their progress.

Analytics

Goal: Visualise performance and export evidence.

Show:

KPI tiles: Throughput now, FPY now, Rejects today.

Charts:

Throughput over last 10 minutes.

FPY over last 10 minutes.

Rejects per minute bar chart.

Export section:

Pick a time window (last 15 min, last hour, today).

Buttons: Export metrics CSV, Export event log CSV.

Confirmation with file name, e.g. SF2_metrics_2025-11-07_1400.csv.

Behavior:

Charts update live from the simulator.

CSV files contain timestamps and values for later analysis.

Success criteria:

Instructor can export a CSV and open it on a PC to mark work.

Settings

Goal: Adjust simulation and app options.

Sections:

Mode:

Simulation (default).

Live (disabled for v0, label says “coming later”).

Simulator knobs:

Speed scaling.

Mix of part types: Steel, Aluminium, Plastic percentages.

Fault settings:

Random faults on/off.

Inject fault buttons: E-Stop, Sensor Stuck, Paddle Jam, Vacuum Leak.

Logging:

Snapshot interval (1 s default).

Data retention (days).

About:

App version, quick help.

Behavior:

Changing mix alters how often each material appears in counts.

Injected faults appear immediately on Home and I/O.

Success criteria:

Instructor can create a scenario: for example, turn on random faults and watch students diagnose.

How the simulation should behave

Time step: internal clock updates 10 times per second.

Parts: the simulator “spawns” imaginary items and moves them along a virtual conveyor.

Sensors toggle when items pass imaginary sensor points.

Auto-sort logic: when the inductive sensor is on, the steel paddle should briefly fire; when the capacitive sensor is on, the aluminium paddle should fire; plastics are counted at the end.

Metrics:

Throughput: items per minute based on current speed.

FPY: good items divided by total items including rejects.

Uptime: time since Start minus any time in Stop or E-Stop.

Faults:

E-Stop: everything stops, outputs disabled until Reset Faults.

Sensor stuck: input tiles stay on, causing bad sorting and rising rejects.

Paddle jam: paddle command does nothing, causing mis-sorts.

Vacuum leak: plunger pick fails intermittently, causing rejects.

Content and wording

Use plain English labels everywhere:

“Start line”, “Stop line”, “Reset faults”, “Conveyor”, “Left paddle”, “Right paddle”, “Photo gate”, “Emergency stop”.

Use short helper text below widgets, for example:

“Plunger blocked while conveyor is running.”

“Outputs are disabled during an emergency stop.”

Data saved by the app

Event log: every time a sensor or output changes, save time, name, and value.

Metrics log: every second, save key metrics (throughput, FPY, counts).

Batch record: when user taps Start on Home, create a batch entry with recipe and target. Close it on Stop.

Safety rules in the UI

Never allow a dangerous combination:

Block plunger actions when conveyor is running.

Block any action while E-Stop is active.

Always explain why a button is disabled.

Provide a single Reset Faults button on Home.

Copy the designer can place on screens

Home:

Title: Smart Factory

Subtitle: Simulation mode

Buttons: Start, Stop, Reset faults

Metrics labels: Produced, Rejects, FPY, Throughput, Uptime

Run:

Title: Run control

Sections: Recipe, Setpoints, Live counters, Manual jog

I/O:

Title: I/O live

Sections: Inputs, Outputs

Worksheets:

Title: Worksheets

Card subtitle example: “Learn how to log data on the factory”

Analytics:

Title: Analytics

Buttons: Export metrics, Export events

Settings:

Titles: Mode, Simulator, Faults, Logging, About

Visual layout quick guide

Cards for groups of info.

Grids for the I/O tiles.

Sliders for speeds and setpoints.

Switches for on/off toggles.

Dialogs for confirmations.

Snackbars for success messages.

Banners for faults at the top in red.

Glossary for beginners

Batch: a production run with a start, a target quantity, and a finish.

Recipe: a named setup, for example the mix of materials and speed.

I/O: Inputs and Outputs. Inputs are sensor signals coming in. Outputs are actuators you control.

FPY: First Pass Yield, the percentage of items that were good the first time.

OEE lite: A simple health score based on uptime, speed, and quality. Shown as an info tile, not for grading.

Milestones and acceptance tests

Milestone 1: Home and simulator

Start/Stop/Reset work, metrics change, uptime ticks.

E-Stop fault stops everything and disables buttons.

Milestone 2: Run and I/O

Recipe and speed change the pace of production.

I/O grid shows inputs and lets you safely pulse outputs.

Interlocks prevent unsafe actions with clear messages.

Milestone 3: Worksheets and Analytics

17 worksheet cards show content, track completion.

Charts update live.

CSV exports open correctly in a spreadsheet.

Milestone 4: Settings and faults

Instructor can change mix and speed scaling.

Random and manual faults behave as described.

When all the above pass on a phone and a tablet, v0 is done.

Future connection plan (later)

Keep all screens and wording the same.

Replace “Simulation mode” with “Connected to PLC” once we add a backend service. The data fields and names remain identical, so the UI needs no redesign.



