//+------------------------------------------------------------------+
//|                                               ExportData.mq4     |
//|              Script to Export Historical Data to CSV             |
//+------------------------------------------------------------------+
#property strict

// Input parameters
input string TargetSymbol = "";     // Symbol (empty = current chart symbol)
input int Timeframe = PERIOD_M1;    // Timeframe (e.g., PERIOD_M1, PERIOD_H1)
input int NumberOfBars = 1000;      // Number of bars to export (0 = all available data)
input string FileName = "HistoricalData.csv"; // Output CSV file name

//+------------------------------------------------------------------+
//| Main Function                                                   |
//+------------------------------------------------------------------+
void OnStart()
{
   // Determine the symbol
   string symbol = (TargetSymbol == "") ? Symbol() : TargetSymbol;

   // Validate inputs
   if (!FileIsValid(FileName)) {
      Print("Invalid file name: ", FileName);
      return;
   }

   if (NumberOfBars < 0) {
      Print("Number of bars must be non-negative.");
      return;
   }

   // Retrieve historical data
   int totalBars = iBars(symbol, Timeframe);
   if (totalBars <= 0) {
      Print("No data available for ", symbol, " on timeframe ", Timeframe);
      return;
   }

   int barsToExport = (NumberOfBars == 0 || NumberOfBars > totalBars) ? totalBars : NumberOfBars;

   // Open the CSV file for writing
   int handle = FileOpen(FileName, FILE_CSV | FILE_WRITE, ";");
   if (handle < 0) {
      Print("Failed to open file: ", FileName);
      return;
   }

   // Write CSV header
   FileWrite(handle, "Time,Open,High,Low,Close,Volume");

   // Export data
   for (int i = barsToExport - 1; i >= 0; i--) {
      datetime time = iTime(symbol, Timeframe, i);
      double open = iOpen(symbol, Timeframe, i);
      double high = iHigh(symbol, Timeframe, i);
      double low = iLow(symbol, Timeframe, i);
      double close = iClose(symbol, Timeframe, i);
      double volume = iVolume(symbol, Timeframe, i);

      // Write data to file
      FileWrite(handle, TimeToString(time, TIME_DATE | TIME_MINUTES), open, high, low, close, volume);
   }

   // Close the file
   FileClose(handle);
   Print("Data successfully exported to ", FileName);
}

//+------------------------------------------------------------------+
//| Validate File Name                                              |
//+------------------------------------------------------------------+
bool FileIsValid(string fileName)
{
   return (StringLen(fileName) > 0 && StringFind(fileName, "\\") == -1 && StringFind(fileName, "/") == -1);
}
