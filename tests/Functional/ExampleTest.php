<?php
declare(strict_types=1);

namespace App\Tests\Functional;

use App\Tests\FunctionalTestCase;

class ExampleTest extends FunctionalTestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function testBasicTest()
    {
        $client = static::createClient();
        $client->request('GET', '/command-scheduler/list');
        // check for 401 due to allow only for user with admin role
        $this->assertEquals(401, $client->getResponse()->getStatusCode());
    }
}
