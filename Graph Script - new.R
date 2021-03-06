library(foreign)
library(MASS)
regAvg_Max=rlm(Avg.CPC~poly(Max.CPC,3,raw="TRUE"))
regPos_Max=rlm(Avg.Pos~poly(Max.CPC,3,raw="TRUE"))
regCTR_Pos=rlm(CTR~Avg.Pos)
Avg_Max_Curve=function(x) regAvg_Max$coefficient[4]*x^3 +regAvg_Max$coefficient[3]*x^2 +regAvg_Max$coefficient[2]*x +regAvg_Max$coefficient[1]
Pos_Max_Curve =function(x) regPos_Max$coefficient[4]*x^3 +regPos_Max$coefficient[3]*x^2 +regPos_Max$coefficient[2]*x +regPos_Max$coefficient[1] 
CTR_Pos_Curve=function(x) regCTR_Pos$coefficient[2]*x +regCTR_Pos$coefficient[1] 
daily_imp=2518/14
revperclick=30
costcurve=function(x) daily_imp*CTR_Pos_Curve(Pos_Max_Curve(x))*Avg_Max_Curve(x)
revcurve=function(x) daily_imp*CTR_Pos_Curve(Pos_Max_Curve(x))*revperclick
absprofitcurve=function(x)revcurve(x)-costcurve(x)
targetrpc=25
gmprofitcurve=function(x) (revcurve(x)/targetrpc)-costcurve(x)
len=length(Max.CPC)
sortmaxcpc=sort(Max.CPC)
maxcpc_top=sortmaxcpc[len]
maxcpc_bot=sortmaxcpc[1]
maxcpcrange=seq(maxcpc_bot,maxcpc_top,by=.05)
avgcpcrange=Avg_Max_Curve(maxcpcrange)
avgposrange=Pos_Max_Curve(maxcpcrange)
ctrrange=CTR_Pos_Curve(avgposrange)
costrange=costcurve(maxcpcrange)
revrange=revcurve(maxcpcrange)
absprofitrange=absprofitcurve(maxcpcrange)
gmprofitrange=gmprofitcurve(maxcpcrange)
plot(maxcpcrange,avgcpcrange,type="l",col="blue",lwd=2)
plot(maxcpcrange,avgposrange,type="l",col="blue",lwd=2)
plot(avgposrange,ctrrange,type="l",col="blue",lwd=2)
plot(maxcpcrange,costrange,type="l",col="blue",lwd=2)
plot(maxcpcrange,revrange,type="l",col="blue",lwd=2)
rpccurve=function(x)revcurve(x)/costcurve(x)
rpcrange=rpccurve(maxcpcrange)
plot(maxcpcrange,rpcrange,type="l",col="blue",lwd=2)
par(new=TRUE)
plot(maxcpcrange,revrange,type="l",col="red",lwd=2,axes="FALSE",ylab="",xlab="")
par(new=TRUE)
plot(maxcpcrange,gmprofitrange,type="l",col="green",lwd=2,axes="FALSE",ylab="",xlab="")
