#include<bits/stdc++.h> 
FILE *fout = freopen("data.txt","w",stdout);
#define random(x) rand()%(x)
int rand(int beg,int end){
	return rand()%(end-beg)+beg;
}
using namespace std;
string xl[] = {"11·","12·","13·","14·","15·","16·","17·","18·","19·","21·","22·","23·","24·","25·","26·","27·","28·","29·","31·","32·","33·","34·","35·","36·","37·","38·","39·","41·","42·","43·","44·","45·","46·","47·","48·","49·","51·","52·","53·","54·","55·","56·","57·","58·","59·","61·","62·","63·","64·","65·","66·","67·","68·","69·","71·","72·","73·","74·","75·","76·","77·","78·","79·","81·","82·","83·","84·","85·","86·","87·","88·","89·","91·","92·","93·","94·","95·","96·","97·","98·","99·"};
string che[] = {"��A82G00","��A82G01","��A82G02","��A82G03","��A82G04","��A82G05","��A82G06","��A82G07","��A82G08","��A82G09","��A82G10","��A82G11","��A82G12","��A82G13","��A82G14","��A82G15","��A82G16","��A82G17","��A82G18","��A82G19","��A82G20","��A82G21","��A82G22","��A82G23","��A82G24","��A82G25","��A82G26","��A82G27","��A82G28","��A82G29","��A82G30","��A82G31","��A82G32","��A82G33","��A82G34","��A82G35","��A82G36","��A82G37","��A82G38","��A82G39","��A82G40","��A82G41","��A82G42","��A82G43","��A82G44","��A82G45","��A82G46","��A82G47","��A82G48","��A82G49","��A82G50","��A82G51","��A82G52","��A82G53","��A82G54","��A82G55","��A82G56","��A82G57","��A82G58","��A82G59","��A82G60","��A82G61","��A82G62","��A82G63"," ��A82G64","��A82G65","��A82G66","��A82G67","��A82G68","��A82G69","��A82G70","��A82G71","��A82G72","��A82G73","��A82G74","��A82G75","��A82G76","��A82G77","��A82G78","��A82G79","��A82G80","��A82G81","��A82G82","��A82G83","��A82G84","��A82G85","��A82G86","��A82G87","��A82G88","��A82G89","��A82G90","��A82G91","��A82G92","��A82G93","��A82G94","��A82G95","��A82G96","��A82G97","��A82G98","��A82G99",
"��A81G00","��A81G01","��A81G02","��A81G03","��A81G04","��A81G05","��A81G06","��A81G07","��A81G08","��A81G09","��A81G10","��A81G11","��A81G12","��A81G13","��A81G14","��A81G15","��A81G16","��A81G17","��A81G18","��A81G19","��A81G20","��A81G21","��A81G22","��A81G23","��A81G24","��A81G25","��A81G26","��A81G27","��A81G28","��A81G29","��A81G30","��A81G31","��A81G32","��A81G33","��A81G34","��A81G35","��A81G36","��A81G37","��A81G38","��A81G39","��A81G40","��A81G41","��A81G42","��A81G43","��A81G44","��A81G45","��A81G46","��A81G47","��A81G48","��A81G49","��A81G50","��A81G51","��A81G52","��A81G53","��A81G54","��A81G55","��A81G56","��A81G57","��A81G58","��A81G59","��A81G60","��A81G61","��A81G62","��A81G63","��A81G64","��A81G65","��A81G66","��A81G67","��A81G68","��A81G69","��A81G70","��A81G71","��A81G72","��A81G73","��A81G74","��A81G75","��A81G76","��A81G77","��A81G78","��A81G79","��A81G80","��A81G81","��A81G82","��A81G83","��A81G84","��A81G85","��A81G86","��A81G87","��A81G88","��A81G89","��A81G90","��A81G91","��A81G92","��A81G93","��A81G94","��A81G95","��A81G96","��A81G97","��A81G98","��A81G99"};
string sex[] = {"��","Ů"};
const string name[] = {"һ","��","��","��","��","��","��","��","��"};
int main() {
	ios::sync_with_stdio(false);
//	cout<<"#���복����Ϣ"<<endl;
//	for(int i=0;i<=9;i++){
//		for(int j=0;j<=9;j++)
//		if(i<3)	cout<<"CALL insert_che(\""<<"��A81G"<<i<<j<<"\","<<random(50)+1<<","<<rand(1,18)<<");"<<endl;
//		else if(i<6)	cout<<"CALL insert_che(\""<<"��A81G"<<i<<j<<"\","<<random(50)+1<<","<<rand(19,36)<<");"<<endl;
//		else if(i<=9)	cout<<"CALL insert_che(\""<<"��A81G"<<i<<j<<"\","<<random(50)+1<<","<<rand(37,54)<<");"<<endl;
//	}
//	for(int i=0;i<=9;i++){
//		for(int j=0;j<=9;j++)
//	if(i<3)	cout<<"CALL insert_che(\""<<"��A82G"<<i<<j<<"\","<<random(50)+1<<","<<rand(55,72)<<");"<<endl;
//		else if(i<6)	cout<<"CALL insert_che(\""<<"��A82G"<<i<<j<<"\","<<random(50)+1<<","<<(73,81)<<");"<<endl;
//		else if(i<=9)	cout<<"CALL insert_che(\""<<"��A82G"<<i<<j<<"\","<<random(50)+1<<","<<82<<");"<<endl;
//	}
//		cout<<"#������·��Ϣ"<<endl;
//		for(int i=0;i<9;i++)
//		for(int j=0;j<9;j++)
//		{
//			
//		
//			if(i<2) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"·\","<<1<<");"<<endl;
//			else if(i<4) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"·\","<<2<<");"<<endl;
//			else if(i<6) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"·\","<<3<<");"<<endl;
//			else if(i<8) cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"·\","<<4<<");"<<endl;
//			else cout<<"CALL insert_xianlu(\""<<i+1<<j+1<<"·\","<<5<<");"<<endl;
//		}
		cout<<"����˾����Ϣ"<<endl;
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
//			cout<<"¼��Υ����Ϣ" <<endl;
//	for(int i=0;i<300;i++){
//		cout<<"CALL insert_weizhangjilu4("<<random(3)+1
//			<<",'"<<2010+random(9)<<"-"<<random(11)+1<<"-"<<random(29)+1<<"',"
//			<<random(1090)+1<<","
//			<<random(3)+1<<");"  
//			<<endl;
//	}
//	
}
