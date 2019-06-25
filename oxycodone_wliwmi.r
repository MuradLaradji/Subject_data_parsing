library(stringi)
df0<-read.csv(file="./oxycodone_oral_2019_wliwmi.csv", header=T, sep="\t")
dim(df0)
head(df0)
names(df0)[c(3,5)]<-c("EID", "AID")
names(df0)

boxplot(log(df0$InactiveLick))
summary(df0$InactiveLick) ## 3rd Qu = 135, use 

# deal with missing inactive data for some rats due to setup error; and some false inactive data due to equiptment failure  (boxes 14,7,1,5)
inactidx<-(df0$Box==14 | df0$Box==7 | df0$Box==1 | df0$Box==5) & df0$InactiveLick>250 # 
inact<-df0$InactiveLick
inact[inactidx]<-NA
range0<-summary(inact,na.rm=T)[c(2,5)] 
df0[is.na(inact),"InactiveLick"]<-round( runif(sum(is.na(inact)),range0[1],range0[2]) ,0) ## fill in the missing data with random number from the same range. Would not do it for the active licks but inactive is OK

head(df0)
table(df0$EID)
# each reward is 60ul of 0.1mg/ml for WMI/WLI
df0$Intake<-df0$Infusion/(df0$BodyWeight/1000)*0.1*0.06
range(df0$Intake,na.rm=T)

df1<-wliwmiM
names(df1)
plotwliwmi<-function(df1, sex0, l){
	print(l)
	df1$strain=substr(df1$EID,4,6)
	means<-aggregate(cbind(ActiveLick, InactiveLick, Infusion, Intake)~Day+strain, FUN=function(x) mean(x,na.rm=T), data=df1)
	ses<-aggregate(cbind(ActiveLick, InactiveLick, Infusion, Intake)~Day+strain, FUN=function(x) sd(x, na.rm=T)/sqrt(length(x)), data=df1)
	ns<-aggregate(AID~Day+strain, FUN=length, data=df1)
	ns_wmi=subset(ns, strain=="WMI")[,3]
	ns_wli=subset(ns, strain=="WLI")[,3]

	xmax=23
	ymax=max(max(means$ActiveLick, na.rm=T) + max(ses$ActiveLick, na.rm=T), 10000)
	x<-subset(means, strain=='WLI' )$Day
	y<-subset(means, strain=='WLI' )$ActiveLick
	err<-subset(ses, strain=='WLI' )$ActiveLic
	plot(x, y , ylab="Number of Licks", xlab="Session", main=paste(l[1], "Licking Behavior,", sex0), type="b", log="y", ylim=c(1, ymax), pch=19, xlim=c(1,xmax), cex.axis=1,col=cols[1], cex=1.5, cex.main=1.5)
	arrows(x, y , x, y + err, angle = 90, length = .02, code = 3,col=cols[1]) 
	x<-subset(means, strain=='WMI' )$Day
	y<-subset(means, strain=='WMI' )$ActiveLick
	err<-subset(ses, strain=='WMI' )$ActiveLick
	lines(x,y, pch=19, type="b", col=cols[2], cex=1.5)
	arrows(x, y, x, y + err, angle = 90, length = .02, code = 3, col=cols[2]) 
	text(x,8, ns_wmi, col=cols[1])
	text(x,12, ns_wli, col=cols[2])
	#
	x<-subset(means, strain=='WLI' )$Day
	y<-subset(means, strain=='WLI' )$InactiveLick
	err<-subset(ses, strain=='WLI' )$InactiveLick
	lines(x, y , type="b", pch=1, lty=2,col=cols[1])
	arrows(x, y , x, y + err, angle = 90, length = .02, code = 3,col=cols[1]) 
	x<-subset(means, strain=='WMI' )$Day
	y<-subset(means, strain=='WMI' )$InactiveLick
	err<-subset(ses, strain=='WMI' )$InactiveLick
	lines(x,y, pch=1, type="b", col=cols[2], lty=2)
	arrows(x, y, x, y + err, angle = 90, length = .02, code = 3, col=cols[2]) 
	#
	legend("topleft", pch=c(19,19), lty=c(1,1), col=rev(cols), c("WMI Active", "WLI Active"), bty="n")
	legend("topright", pch=c(1,1), lty=c(2,2), col=rev(cols), c("WMI Inactive", "WLI Inactive"), bty="n")
	abline(h=c(1,10,100,1000,10000), lty=3, col="grey60")
	abline(v=c(5.5, 15.5, 17.5,20.5), lty=2, col="grey")
	text(c(2.5, 10,18), 2, c("1 h", "6 h", "Ext."),font=2)
	text(16, 2, "PR", font=2)
	text(21, 2, "Reinst.", srt=90, font=2)

	#
#	ymax=max(means$Infusion) + max(ses$Infusion)
#	x<-subset(means, strain=='WLI' )$Day
#	y<-subset(means, strain=='WLI' )$Infusion
#	err<-subset(ses, strain=='WLI' )$Infusion
#	plot(x,y, pch=15, type="b",col=cols[1], ylab="Number of rewards", main=paste("Rewards", sex0),  xlab="Session", ylim=c(2,500), xlim=c(1,xmax), log="y")
#	arrows(x, y, x, y + err, angle = 90, length = .02, code = 3, col=cols[1]) 
	#
#	x<-subset(means, strain=='WMI' )$Day
#	y<-subset(means, strain=='WMI' )$Infusion
#	err<-subset(ses, strain=='WMI' )$Infusion
#	lines(x,y, pch=15, type="b",col=cols[2])
#	arrows(x, y, x, y + err, angle = 90, length = .02, code = 3, col=cols[2]) 
#	legend("topleft", col=rev(cols), lty=1, pch=15, c("WMI, Male, n=6", "WLI, Male, n=5"), bty='n')
#	abline(h=c(1,5,10,50,100,500,1000,5000,10000), lty=3, col="grey60")
#	abline(v=c(5.5, 15.5), lty=2)
	#

	means<-subset(means, Day<=17)
	ses<-subset(ses, Day<=17)
	x<-subset(means, strain=='WLI' )$Day
	y<-subset(means, strain=='WLI' )$Intake
	err<-subset(ses, strain=='WLI' )$Intake
	xmax=17
	plot(x,y, pch=15, type="b",col=cols[1], ylab="Intake (mg/kg)", main=paste(l[2], "Intake,", sex0), xlab="Session", ylim=c(0.05,10), xlim=c(1,xmax), log="y", cex=1.5, cex.main=1.5)
	arrows(x, y, x, y + err, angle = 90, length = .02, code = 3, col=cols[1]) 
	#
	x<-subset(means, strain=='WMI' )$Day
	y<-subset(means, strain=='WMI' )$Intake
	err<-subset(ses, strain=='WMI' )$Intake
	lines(x,y, pch=15, type="b",col=cols[2], cex=1.5)
	arrows(x, y, x, y + err, angle = 90, length = .02, code = 3, col=cols[2]) 
	legend("topleft", col=rev(cols), lty=1, pch=15, c("WMI", "WLI"), bty='n')
	abline(h=c(1,5), lty=3, col="grey60")
	abline(v=c(5.5, 15.5), lty=2, col='grey')
	text(c(2.5, 10), 0.07, c("1 h", "6 h"))
	text(16, 0.07, "PR",  font=2)
	text(x,0.1, ns_wmi[1:xmax], col=cols[1])
	text(x,0.15, ns_wli[1:xmax], col=cols[2])
	
}

table(df0$EID)
df0<-subset(df0, ! is.na(Day) & Day<=21)
wliwmiM<-subset(df0, EID=="oxyWLI100M" | EID=="oxyWMI100M")
wliwmiF<-subset(df0, EID=="oxyWLI100F" | EID=="oxyWMI100F")
cols=c("#ec0000", "#132dfe") # eva color

ti<-"oxycodone_wli_wmi.eps"
postscript(file=ti,width=8,height=8,onefile=F,horizontal=F,paper="special") 
par(mfrow=c(2,2), font=2)
plotwliwmi(wliwmiM, "Male", c("A.", "B."))
plotwliwmi(wliwmiF, "Female", c("C.", "D."))
dev.off()

head(wliwmiM)

## stats
wliwmi<-rbind(wliwmiM, wliwmiF)
wliwmi$sex
wliwmi$sex<- stri_sub(wliwmi$EID, -1,-1)
wliwmi$strain<- stri_sub(wliwmi$EID, 4,6)
#wliwmi<-subset(wliwmi, Day<=10)
names(wliwmi)
# first five days
summary(aov(Intake~strain*sex*as.factor(Day)+Error(AID/as.factor(Day)), data=subset(wliwmi, Day<=5)))
# day six to 16
summary(aov(Intake~strain*sex*as.factor(Day)+Error(AID/as.factor(Day)), data=subset(wliwmi, Day>=6 & Day<16)))
# day six to 16, females
summary(aov(Intake~strain*as.factor(Day)+Error(AID/as.factor(Day)), data=subset(wliwmi, Day>=6 & Day<16 & sex=='F')))
# day six to 16, males 
summary(aov(Intake~strain*as.factor(Day)+Error(AID/as.factor(Day)), data=subset(wliwmi, Day>=6 & Day<16 & sex=='M')))
## day 16 and 17 (progressive ratio)
summary(aov(Intake~strain*sex*as.factor(Day)+Error(AID/as.factor(Day)), data=subset(wliwmi, Day==16 | Day==17)))
## pr for male
summary(aov(Intake~strain*as.factor(Day)+Error(AID/as.factor(Day)), data=subset(wliwmi, Day==16 | Day==17 & sex=='M')))
## pr for female
summary(aov(Intake~strain*as.factor(Day)+Error(AID/as.factor(Day)), data=subset(wliwmi, Day==16 | Day==17 & sex=='F')))

summary(aov(Intake~strain*sex, data= subset(wliwmi, Day==16)))
TukeyHSD(aov(Intake~strain*sex, data=subset(wliwmi, Day==16)))
summary(aov(ActiveLick~strain*sex, data= subset(wliwmi, Day==21)))

table(subset(wliwmi,  Day==1)[,c("sex","strain")])


dim(df0)
names(df0)
unique(df0$EID)
df0$sex<-"M"
f<-df0$EID=="oxyWMIf" | df0$EID=="oxyWLIf"
df0$sex[f]<-"F"
df0$strain<-"WMI"
wli<-df0$EID=="oxyWLIf" | df0$EID=="oxyWLIm"
df0$strain[wli]<-"WLI"

se<-function(x){sd(x)/sqrt(length(x))}

effectSize<-subset(df0, Day>6 & Day<15)
ms<-aggregate(Intake ~ strain+sex, FUN=mean, data=effectSize)
ss<-aggregate(Intake ~ strain+sex, FUN=se, data=effectSize)
write.table(file="wliwmi_effectsize.csv",cbind(ms, ss))

cohen.d(Intake ~ strain, data=subset(effectSize, sex=="M"))
cohen.d(Intake ~ strain, data=subset(effectSize, sex=="F"))

