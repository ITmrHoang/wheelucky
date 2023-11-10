<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DataSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('data')->insert(
            [
                [
                    'name' => "data",
                    'data' => null,

                ],
                [
                    'name' => "background",
                    'data' => 'white',
                ],
        ]);
    }
}
