unit unit_login_register;

{Unit untuk melakukan login dan register}

interface

uses
	unit_csv, unit_type;
	
{Fungsi untuk login yang mengeluarkan string nama pengunjung sekaligus mengecek apakah dia admin atau tidak}
function login(var data : textfile; var tabel : tabel_data; var isAdmin : boolean) : string;

{Prosedur untuk meregistrasi user yang hanya dapat dilakukan oleh admin}
procedure register_(var data : textfile; var tabel : tabel_data);


implementation

procedure hashpassword(var pass : string);
{Prosedur untuk menghash password sesuai algoritma yang diinginkan yaitu string hashing}


{Konstanta yang digunakan}
const
	modulo = 10000007; {10^9 + 7}
	prima = 31; {bilangan prima yang dipilih}

{KAMUS LOKAL}
var
	i, temp: integer;
	hashbil : integer; // bilangan yang dihasilkan dari hash
	
{ALGORITMA}
begin
	
	hashbil := 0;
	temp := prima;
	for i := 1 to length(pass) do begin 
		hashbil := ((hashbil + (ord(pass[i]) * temp)) mod modulo + modulo) mod modulo;
		pass[i] := chr(32 + (95 + hashbil mod 95) mod 95);
		if (pass[i] = ',') then begin {ubah ',' menjadi '*' untuk mencegah terjadinya penambahan kolom pada csv}
			pass[i] := '*';
		end;
	end;
	
	{append hasil hash string dengan hasil hash bilangan}
	pass := pass + IntToStr(hashbil);

end;

function login(var data : textfile; var tabel : tabel_data; var isAdmin : boolean) : string;

var
	A : string;
	B : string;		//melakukan inisiasi tipe data
	i : integer;
	found : boolean;
	array_user : array_of_user;
	banyak_user : integer;
	
begin


	found := False;
	
	while not found do begin
		//melakukan inputan 
		write('Masukkan username : ');
		readln (A);
		write ('Masukkan password : ');
		readln (B);
		hashpassword(B);
		found := False;
		
		array_user := buat_array_user(tabel);
		banyak_user := Length(array_user);
		 
		for i:= 1 to banyak_user - 1  do //melakukan pengulangan yang akan digunakan untuk mencari username serta password
		begin
			if (array_user[i].username =A) and (array_user[i].password=B) then //melakukan pencarian password serta username yang sama dari baris yang sama
			begin
				writeln ('Selamat datang ', array_user[i].nama, '!');
				found := True;
				login := A;
				if (array_user[i].role = 'admin') then begin
					isAdmin := True;
				end else begin
					isAdmin := False;
				end;
			end;
		end;
		
		if not found then  //apabila password serta username yang dimasukkan tidak dalam 1 baris yang sama
		begin
			writeln ('Username / password salah! Silakan coba lagi.');
		end;
	end;
	
end;



procedure register_(var data : textfile; var tabel : tabel_data);

var
	banyak_user : integer;
	array_user :array_of_user;
	
begin

	array_user := buat_array_user(tabel);
	banyak_user :=Length(array_user);
	
	//Pengisian baris baru yang kosong dengan data registrasi
	setLength(array_user, banyak_user + 1);

	write('Masukkan nama pengunjung: ');	
	readln(array_user[banyak_user].nama);
	write('Masukkan alamat pengunjung: ');	
	readln(array_user[banyak_user].alamat);							
	write('Masukkan username pengunjung: ');
	readln(array_user[banyak_user].username);
	write('Masukkan password pengunjung: ');
	readln(array_user[banyak_user].password);
	
	hashpassword(array_user[banyak_user].password);
	
	array_user[banyak_user].role := 'pengunjung';
	
	writeln('Pengunjung ', (array_user[banyak_user].nama), ' berhasil terdaftar sebagai user.');
	
	masukkan_array_user(array_user, tabel);
end;

end.
