df<-read.table("household_power_consumption.txt", stringsAsFactors = FALSE, header = TRUE, sep =";")
df1<-df[df$Date=="1/2/2007" | df$Date=="2/2/2007",]
df1$Global_active_power<-as.numeric(df1[,"Global_active_power"])
png("file1.png")
hist(df1$Global_active_power,col = "red",main="Global Active Power",xlab = "Global Active Power (kilowatts)")
dev.off()