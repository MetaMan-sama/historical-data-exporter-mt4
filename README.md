# Historical Data Exporter — MQL4 Script

A MetaTrader 4 script that **exports historical OHLCV bar data** for a configurable symbol and timeframe to a semicolon-delimited CSV file via `FileOpen(FILE_CSV | FILE_WRITE)`, iterating bars from most recent to oldest using `iTime()`, `iOpen()`, `iHigh()`, `iLow()`, `iClose()`, and `iVolume()`, writing each row via `FileWrite()` with a human-readable `TimeToString(time, TIME_DATE | TIME_MINUTES)` timestamp, and confirming completion via the Experts tab — providing a clean, repeatable pipeline for extracting MT4 historical data for external analysis, backtesting feeds, or machine learning model training.

---

## Overview

Accessing MetaTrader 4's historical bar data programmatically is a fundamental requirement for any quantitative workflow that extends beyond the terminal itself — whether feeding a Python backtesting engine, training a machine learning model on price history, building a spreadsheet dashboard, or validating data quality against an external feed. This script provides a direct, auditable export mechanism using MT4's native `FileOpen()` CSV API, writing a clean structured file with one bar per row. The configurable `NumberOfBars` parameter controls the export depth — defaulting to `0` for all available bars, or accepting any positive integer for a rolling window export. A `FileIsValid()` guard validates the output filename before any file operations are attempted, and each bar is written in strict reverse-chronological order (most recent bar first) matching the standard MT4 bar indexing convention.

> **Note on file naming:** This file is distributed as `Trailing_Stop_Adjustment_001.mq4` but implements a Historical Data CSV Exporter. The README documents the actual implemented logic.

---

## Features

- **Full OHLCV export** — `iTime()`, `iOpen()`, `iHigh()`, `iLow()`, `iClose()`, `iVolume()` fetched per bar; written via `FileWrite(handle, TimeToString(time, TIME_DATE | TIME_MINUTES), open, high, low, close, volume)` — six fields per row in semicolon-delimited format
- **`NumberOfBars` depth control** — `barsToExport = (NumberOfBars == 0 || NumberOfBars > totalBars) ? totalBars : NumberOfBars` — `0` exports all available bars; positive integer caps the export window
- **`TargetSymbol` dynamic resolution** — `symbol = TargetSymbol == "" ? Symbol() : TargetSymbol` defaults to the active chart symbol; accepts any explicit symbol available in Market Watch
- **`FileIsValid()` filename guard** — validates `StringLen(FileName) > 0 && StringFind(FileName, "\\") == -1 && StringFind(FileName, "/") == -1` before file operations; aborts with log on invalid filename
- **`FILE_CSV | FILE_WRITE` sandbox output** — file written to `%APPDATA%\MetaQuotes\Terminal\<ID>\MQL4\Files\` with `;` delimiter; header row written before data: `Time;Open;High;Low;Close;Volume`
- **`FileClose(handle)` unconditional cleanup** — file handle closed regardless of loop completion status; final `Print("Data successfully exported to", FileName)` confirms success

---

## How It Works

1. `symbol` resolved; `FileIsValid(FileName)` checked; aborts if invalid
2. `totalBars = iBars(symbol, Timeframe)`; `barsToExport` computed from `NumberOfBars` vs `totalBars`
3. `FileOpen(FileName, FILE_CSV | FILE_WRITE, ';')` opens output; header row written
4. `for (int i = barsToExport − 1; i >= 0; i--)`: fetches all six fields and calls `FileWrite()`
5. `FileClose(handle)`; completion print

---

## Output File Format

```
Time;Open;High;Low;Close;Volume
2026.05.01 08:00;1.08420;1.08510;1.08380;1.08490;1842
2026.05.01 09:00;1.08490;1.08640;1.08450;1.08610;2103
```

> File path: `%APPDATA%\MetaQuotes\Terminal\<TerminalID>\MQL4\Files\HistoricalData.csv`

---

## Input Parameters

| Parameter       | Type            | Default               | Description                                              |
|-----------------|-----------------|-----------------------|----------------------------------------------------------|
| `TargetSymbol`  | string          | `""`                  | Symbol to export (empty = current chart symbol)          |
| `Timeframe`     | ENUM_TIMEFRAMES | `PERIOD_M1`           | Timeframe for bar data export                            |
| `NumberOfBars`  | int             | `1000`                | Number of bars to export (0 = all available bars)        |
| `FileName`      | string          | `HistoricalData.csv`  | Output CSV filename in the MT4 Files sandbox             |

---

## Installation

1. Copy `Trailing_Stop_Adjustment_001.mq4` to `MQL4/Scripts/` in your MT4 data folder
2. Compile in MetaEditor (F7)
3. Drag onto any chart from Navigator → Scripts
4. Configure inputs and click **OK**
5. Retrieve the CSV from `MQL4/Files/` in the MT4 data directory

---

## Requirements

- MetaTrader 4 (`#property strict` compatible build)
- MQL4 compiler (MetaEditor)

---

## License

MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
