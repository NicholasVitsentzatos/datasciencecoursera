df<-read.table("household_power_consumption.txt", stringsAsFactors = FALSE, header = TRUE, sep =";")
df1<-df[df$Date=="1/2/2007" | df$Date=="2/2/2007",]
df1$Global_active_power<-as.numeric(df1[,"Global_active_power"])
df1$DT<-paste(df1$Date,df1$Time,sep=" ")
df1$DT<-strptime(df1$DT, "%d/%m/%Y %H:%M:%S")
png("file2.png")
with(df1, plot(DT, Global_active_power, type="l", xlab="Day", ylab="Global Active Power (kilowatts)"))
dev.off()