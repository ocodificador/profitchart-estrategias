input
 FastAvgLen(7);
 SlowAvgLen(15);
 Trend_Period(4); 
 Noise_Period(250); 
 Correction(2); 
var
  Reversals : Float;
  Periods   : Float;
  DC        : Float;
  CPC       : Float;
  Trend     : Float;
  DT        : Float;
  Noise     : Float;
  QIND      : Float;
  BIND      : Float;
  Result    : Float;
begin
  { Gera sinais de reversão com base na regra de cruzamento das médias }
  Reversals := XAverage( CLOSE, FastAvgLen ) - XAverage( CLOSE, SlowAvgLen ) ;

  Periods   := Sign( Reversals );

  { Calcular preço menos preço anterior e calcular a soma acumulada ao longo de períodos dados por reversões }
  DC        := CLOSE - CLOSE[1] ;
  
  if Periods <> Periods[1] then
  begin
    CPC   := 0;
    Trend := 0;
  end
  else
  begin
    CPC   := CPC + DC * Periods ;
   
    { Para calcular a tendência, reduza o CPC por EMA de Trend_Period nos segmentos especificados (periods) }
    Trend := CPC * 1 / Trend_Period + Trend[1] * ( 1 - ( 1 / Trend_Period ) ) ;
  end;
  
  { Para calcular o ruído, subtraia a tendência do CPC, ajuste-a ao quadrado e suavise a danada }
  DT    := CPC - Trend ;
  Noise := Correction * Sqrt( Media( Noise_Period,  DT * DT ) );

  { Para calcular o Q-Indicator divida a tendência pelo ruído obtido }
  if Noise > 0 then QIND := Trend / Noise;

  { Para calcular o B-Indicator faça o que estar aí na próxima linha }
  BIND := Abs( Trend ) / ( Abs( Trend ) + Abs( Noise ) ) * 100; 
  
  Plot(BIND);
  
end;
