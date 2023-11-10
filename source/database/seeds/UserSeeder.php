<?php

use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->insert(
            [
                [
                    'name' => "Hoang",
                    'email' =>'itmrhoang@gmail.com',
                    'password' => Hash::make('passwordmrH2510@'),
                ],
                [
                    'name' => "administrate",
                    'email' =>'administrate@gmail.com',
                    'password' => Hash::make('Administrate@'),
                ],
        ]);
    }
}
