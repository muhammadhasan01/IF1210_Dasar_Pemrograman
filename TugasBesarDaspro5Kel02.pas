program TugasBesarDaspro5Kel02;

{TUGAS BESAR DASAR PEMROGRAMAN 5 - KELOMPOK 2}

{ANGGOTA KELOMPOK 02 :
* Muhammad Hasan			: 16518012
* Adella Savira Putri		: 16518096
* Dita Rananta Natasha		: 16518173
* Rakha Fadhilah			: 16518250
* Faris Muhammad Kautsar	: 16518327
* Muhamad Rizki Nashirudin	: 16518404
* }

uses
	unit_csv, unit_type, unit_load_save_exit, unit_pelaporan, unit_login_register, unit_pencarian, unit_penambahan_buku;

{KAMUS}
var
	nama_pengunjung : string; {nama user/pengunjung}
	buku,user,peminjaman,pengembalian,kehilangan : textfile; {textfile yang akan menghubungkan file csv}
	tabelbuku, tabeluser, tabelpengembalian, tabelkehilangan, tabelpeminjaman : tabel_data; {tabel atau hasil parse dari textfile}
	input : string; {input dari pengunjung/admin}
	char_exit : char; {variabel char untuk mengecek apakah user akan keluar dari program atau tidak}
	isLogin : boolean; {variabel untuk mengecek apakah sudah login atau belum}
	isAdmin : boolean; {variabel untuk mengecek apakah user admin atau bukan}
{ALGORITMA}
begin
	input := '$ load'; {program pertama-tama akan menyuruh untuk meload file terlebih dahulu}
	isLogin := false;
	isAdmin := false;
	
	writeln('~ Selamat datang di program perpustakaan Wan Shi Tong ~');
	writeln('Silahkan load terlebih dahulu dengan mengisi nama file ');
	while True do begin	
	
		if (input = '$ register') and (isAdmin) then begin
			register_(user, tabeluser);
		end else if (input = '$ login') then begin
			nama_pengunjung := login(user,tabeluser,isAdmin);
			isLogin := true;
		end else if (input = '$ cari') then begin
			if isLogin then begin
				carikategori(buku, tabelbuku);
			end else begin
				writeln('Anda belum login!');
			end;			
		end else if (input = '$ caritahunterbit') then begin
			if isLogin then begin
				caritahun(buku, tabelbuku);
			end else begin
				writeln('Anda belum login!');
			end;				
		end else if (input = '$ pinjam_buku') then begin
			if isLogin then begin
				peminjaman_(buku,peminjaman,tabelbuku,tabelpeminjaman,nama_pengunjung);
			end else begin
				writeln('Anda belum login!');
			end;
		end else if (input = '$ kembalikan_buku') then begin
			if isLogin then begin
				pengembalian_(peminjaman,pengembalian,buku,tabelpeminjaman,tabelpengembalian,tabelbuku,nama_pengunjung);
			end else begin
				writeln('Anda belum login!');
			end;
		end else if (input = '$ lapor_hilang') then begin
			if isLogin then begin
				laporhilang(kehilangan, tabelkehilangan, nama_pengunjung);
			end else begin
				writeln('Anda belum login!');
			end;
		end else if (input = '$ lihat_laporan') and (isAdmin) then begin
			lihat_laporan(buku,kehilangan,tabelkehilangan,tabelbuku);
		end else if (input = '$ tambah_buku') and (isAdmin) then begin
			tambah_buku(buku, tabelbuku);
		end else if (input = '$ tambah_jumlah_buku') and (isAdmin) then begin
			tambah_jumlah_buku(buku, tabelbuku);
		end else if (input = '$ riwayat') and (isAdmin) then begin
			riwayat(peminjaman,buku,tabelpeminjaman,tabelbuku);	
		end else if (input = '$ statistik') and (isAdmin) then begin
			statistik(user,buku,tabeluser,tabelbuku);
		end else if (input = '$ load') then begin
			load(buku,user,peminjaman,pengembalian,kehilangan,tabelbuku,tabeluser,tabelpeminjaman,tabelkehilangan,tabelpengembalian);
		end else if (input = '$ save') then begin
			save(buku,user,peminjaman,pengembalian,kehilangan,
			tabelbuku,tabeluser, tabelpeminjaman, tabelkehilangan, tabelpengembalian);
		end else if (input = '$ cari_anggota') and (isAdmin) then begin
			carianggota(user,tabeluser);
		end else if (input = '$ exit') then begin
			write('Apakah anda mau melakukan penyimpanan file yang sudah dilakukan (Y/N) ? ');
			readln(char_exit);
			if(char_exit = 'Y') then begin
				save(buku,user,peminjaman,pengembalian,kehilangan,
			tabelbuku,tabeluser, tabelpeminjaman, tabelkehilangan, tabelpengembalian);
			end;
			break;
		end;
		
		writeln();
		
			if isLogin then begin
			writeln('Menu yang tersedia :');
			writeln('(1) $ login');
			writeln('(2) $ cari');
			writeln('(3) $ caritahunterbit');
			writeln('(4) $ pinjam_buku');
			writeln('(5) $ kembalikan_buku');
			writeln('(6) $ lapor_hilang');
			writeln('(7) $ save');
			writeln('(8) $ load');
			writeln('(9) $ exit');
			
			if isAdmin then begin
				writeln();
				writeln('Menu tambahan untuk admin :');
				writeln('(1) $ register');
				writeln('(2) $ tambah_buku');
				writeln('(3) $ tambah_jumlah_buku');
				writeln('(4) $ statistik');
				writeln('(5) $ lihat_laporan');
				writeln('(6) $ riwayat');
				writeln('(7) $ cari_anggota');
			end;
			writeln();
			
		end else if not isLogin then begin
			writeln('Silahkan terlebih dahulu login dengan mengetik $ login');
		end;
		
		readln(input);
	end;
end.
