#include<bits/stdc++.h> 
FILE *fout = freopen("data.txt","w",stdout);
#define random(x) rand()%(x)
int rand(int beg,int end){
	return rand()%(end-beg)+beg;
}
using namespace std;
string xl[] = {"11Â·","12Â·","13Â·","14Â·","15Â·","16Â·","17Â·","18Â·","19Â·","21Â·","22Â·","23Â·","24Â·","25Â·","26Â·","27Â·","28Â·","29Â·","31Â·","32Â·","33Â·","34Â·","35Â·","36Â·","37Â·","38Â·","39Â·","41Â·","42Â·","43Â·","44Â·","45Â·","46Â·","47Â·","48Â·","49Â·","51Â·","52Â·","53Â·","54Â·","55Â·","56Â·","57Â·","58Â·","59Â·","61Â·","62Â·","63Â·","64Â·","65Â·","66Â·","67Â·","68Â·","69Â·","71Â·","72Â·","73Â·","74Â·","75Â·","76Â·","77Â·","78Â·","79Â·","81Â·","82Â·","83Â·","84Â·","85Â·","86Â·","87Â·","88Â·","89Â·","91Â·","92Â·","93Â·","94Â·","95Â·","96Â·","97Â·","98Â·","99Â·"};
string che[] = {"ºÚA82G00","ºÚA82G01","ºÚA82G02","ºÚA82G03","ºÚA82G04","ºÚA82G05","ºÚA82G06","ºÚA82G07","ºÚA82G08","ºÚA82G09","ºÚA82G10","ºÚA82G11","ºÚA82G12","ºÚA82G13","ºÚA82G14","ºÚA82G15","ºÚA82G16","ºÚA82G17","ºÚA82G18","ºÚA82G19","ºÚA82G20","ºÚA82G21","ºÚA82G22","ºÚA82G23","ºÚA82G24","ºÚA82G25","ºÚA82G26","ºÚA82G27","ºÚA82G28","ºÚA82G29","ºÚA82G30","ºÚA82G31","ºÚA82G32","ºÚA82G33","ºÚA82G34","ºÚA82G35","ºÚA82G36","ºÚA82G37","ºÚA82G38","ºÚA82G39","ºÚA82G40","ºÚA82G41","ºÚA82G42","ºÚA82G43","ºÚA82G44","ºÚA82G45","ºÚA82G46","ºÚA82G47","ºÚA82G48","ºÚA82G49","ºÚA82G50","ºÚA82G51","ºÚA82G52","ºÚA82G53","ºÚA82G54","ºÚA82G55","ºÚA82G56","ºÚA82G57","ºÚA82G58","ºÚA82G59","ºÚA82G60","ºÚA82G61","ºÚA82G62","ºÚA82G63"," ºÚA82G64","ºÚA82G65","ºÚA82G66","ºÚA82G67","ºÚA82G68","ºÚA82G69","ºÚA82G70","ºÚA82G71","ºÚA82G72","ºÚA82G73","ºÚA82G74","ºÚA82G75","ºÚA82G76","ºÚA82G77","ºÚA82G78","ºÚA82G79","ºÚA82G80","ºÚA82G81","ºÚA82G82","ºÚA82G83","ºÚA82G84","ºÚA82G85","ºÚA82G86","ºÚA82G87","ºÚA82G88","ºÚA82G89","ºÚA82G90","ºÚA82G91","ºÚA82G92","ºÚA82G93","ºÚA82G94","ºÚA82G95","ºÚA82G96","ºÚA82G97","ºÚA82G98","ºÚA82G99",
"ºÚA81G00","ºÚA81G01","ºÚA81G02","ºÚA81G03","ºÚA81G04","ºÚA81G05","ºÚA81G06","ºÚA81G07","ºÚA81G08","ºÚA81G09","ºÚA81G10","ºÚA81G11","ºÚA81G12","ºÚA81G13","ºÚA81G14","ºÚA81G15","ºÚA81G16","ºÚA81G17","ºÚA81G18","ºÚA81G19","ºÚA81G20","ºÚA81G21","ºÚA81G22","ºÚA81G23","ºÚA81G24","ºÚA81G25","ºÚA81G26","ºÚA81G27","ºÚA81G28","ºÚA81G29","ºÚA81G30","ºÚA81G31","ºÚA81G32","ºÚA81G33","ºÚA81G34","ºÚA81G35","ºÚA81G36","ºÚA81G37","ºÚA81G38","ºÚA81G39","ºÚA81G40","ºÚA81G41","ºÚA81G42","ºÚA81G43","ºÚA81G44","ºÚA81G45","ºÚA81G46","ºÚA81G47","ºÚA81G48","ºÚA81G49","ºÚA81G50","ºÚA81G51","ºÚA81G52","ºÚA81G53","ºÚA81G54","ºÚA81G55","ºÚA81G56","ºÚA81G57","ºÚA81G58","ºÚA81G59","ºÚA81G60","ºÚA81G61","ºÚA81G62","ºÚA81G63","ºÚA81G64","ºÚA81G65","ºÚA81G66","ºÚA81G67","ºÚA81G68","ºÚA81G69","ºÚA81G70","ºÚA81G71","ºÚA81G72","ºÚA81G73","ºÚA81G74","ºÚA81G75","ºÚA81G76","ºÚA81G77","ºÚA81G78","ºÚA81G79","ºÚA81G80","ºÚA81G81","ºÚA81G82","ºÚA81G83","ºÚA81G84","ºÚA81G85","ºÚA81G86","ºÚA81G87","ºÚA81G88","ºÚA81G89","ºÚA81G90","ºÚA81G91","ºÚA81G92","ºÚA81G93","ºÚA81G94","ºÚA81G95","ºÚA81G96","ºÚA81G97","ºÚA81G98","ºÚA81G99"};
string sex[] = {"ÄÐ","Å®"};
const string name[] = {"Ò»","¶þ","Èý","ËÄ","Îå","Áù","Æß","°Ë","¾Å"};
int main() {
	ios::sync_with_stdio(false);
//	cout<<"#²åÈë³µÁ¾ÐÅÏ¢"<<endl;
//	for(int i=0;i<=9;i++){
//		for(int j=0;j<=9;j++)
//		if(i<3)	cout<<"CALL insert_che(\""<<"ºÚA81G"<<i<<j<<"\","<<random(50)+1<<","<<rand(1,18)<<");"<<endl;
//		else if(i<6)	cout<<"CALL insert_che(\""<<"ºÚA81G"<<i<<j<<"\","<<random(50)+1<<","<<rand(19,36)<<");"<<endl;
//		else if(i<=9)	cout<<"CALL insert_che(\""<<"ºÚA81G"<<i<<j<<"\","<<random(50)+1<<","<<rand(37,54)<<");"<<endl;
//	}
//	for(int i=0;i<=9;i++){
//		for(int j=0;j<=9;j++)
//	if(i<3)	cout<<"CALL insert_che(\""<<"ºÚA82G"<<i<<j<<"\","<<random(50)+1<<","<<rand(55,72)<<");"<<endl;
//		else if(i<6)	cout<<"CALL insert_che(\""<<"ºÚA82G"<<i<<j<<"\","<<random(50)+1<<","<<(73,81)<<");"<<endl;
//		else if(i<=9)	cout<<"CALL insert_che(\""<<"ºÚA82G"<<i<<j<<"\","<<random(50)+1<<","<<82<<");"<<endl;
//	}
//		cout<<"#²åÈëÏßÂ·ÐÅÏ¢"<<endl;
//		for(int i=0;i<9;i++)
//		for(int j=0;j<9;j++)
//		{
//			
//		
//			if(i<2) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"Â·\","<<1<<");"<<endl;
//			else if(i<4) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"Â·\","<<2<<");"<<endl;
//			else if(i<6) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"Â·\","<<3<<");"<<endl;
//			else if(i<8) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"Â·\","<<4<<");"<<endl;
//			else cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"Â·\","<<5<<");"<<endl;
//		}
		cout<<"²åÈëË¾»úÐÅÏ¢"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[random(29)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(30,59)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(60,89)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(90,119)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(120,149)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(150,179)]<<"\");"<<endl;		
					for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[random(29)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(30,59)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(60,89)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(90,119)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(120,149)]<<"\");"<<endl;
			for(int k = 0;k<100;k++)
				cout<<"CALL insert_siji(\""<<name[random(8)+1]<<name[random(8)+1]<<name[random(8)+1]<<"\","
					<<"\""<<sex[random(1)]<<"\","
					<<"\""<<che[rand(150,179)]<<"\");"<<endl;
//			cout<<"Â¼ÈëÎ¥ÕÂÐÅÏ¢" <<endl;
//	for(int i=0;i<300;i++){
//		cout<<"CALL insert_weizhangjilu4("<<random(3)+1
//			<<",'"<<2010+random(9)<<"-"<<random(11)+1<<"-"<<random(29)+1<<"',"
//			<<random(1090)+1<<","
//			<<random(3)+1<<");"  
//			<<endl;
//	}
//	
}
