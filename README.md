# Waktu Sholat (Swift)

Terinspirasi dari program jadwal shalat dari pak Thomas Djamaluddin di bahasa pemrogaman basic [Blog pak thomas djamaluddin bahas program jadwal shalat](https://tdjamaluddin.wordpress.com/2010/12/09/program-jadwal-shalat/)

## Cara install
* git clone repository ini
* masuk folder proyek ini menggunakan terminal
* masuk ke folder WaktuSholat
* swift main.swift
  

## Teori
```
sholatTime = localTime - longitudeHours + timezone
```
untuk mendapatkan **localTime** berdasarkan posisi matahari yaitu waktu ketika matahari berada pada posisi tertentu di langit relatif terhadap lokasi tertentu di Bumi. Sebagai contoh, untuk menghitung waktu terbenam, kita akan mencari waktu ketika matahari berada tepat di horizon. apa saja yang diperlukan untuk mendapatkan localTime:
 1. Koordinat geografis
    - longtitude dan latitude yang di input oleh user
 2. Tanggal dan zona waktu
    - tanggal saat ini : untuk mengetahui posisi relatif bumi dalam orbitnya mengelilingi matahari
    - zona waktu: perbedaan zona waktu dan indonesia masuk UTC +7
 3. Tanggal julian
    - sistem penanggalan yang digunakan dalam astronomi untuk menentukan posisi benda langit pada waktu tertentu
4. Bujur matahari
   - diperlukan untuk menghitung posisi matahari di langit pada waktu tertentu
5. Koreksi ekuasi waktu
   - koreksi diperlukan karena orbit bumi mengelilingi matahari tidak sempurna lingkaran, dan kemiripan sumbu rotasi bumi. koreksi ini mempengaruhi perbedaan antara waktu matahari nyata dan matahari rata rata.
6. Sudut jam
   - sudut ini menunjukkan perbedaan waktu antara posisi matahari saat ini dan posisi matahari pada tengah hari

**longitudeHours** konversi longitude yang di input user dari derajat ke jam

**timeZone** zona waktu indonesia utc +7

## Contoh
| cara install |
| --- |
|  <video src="https://github.com/nvnthermawan12/WaktuSholat/assets/74716034/e7b67e6c-f7be-4722-bb14-43404fc7c829"> |
               
