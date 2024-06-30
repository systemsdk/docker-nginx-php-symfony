<?php

declare(strict_types=1);

namespace App\Tests\Application;

use App\Tests\ApplicationTestCase;
use Throwable;

/**
 * @package App\Tests
 */
class ExampleTest extends ApplicationTestCase
{
    /**
     * A basic test example.
     *
     * @throws Throwable
     */
    public function testBasicTest(): void
    {
        $client = static::createClient();
        $client->request('GET', '/command-scheduler/list');
        // check for 401 due to allow only for user with admin role
        static::assertSame(401, $client->getResponse()->getStatusCode());
    }
}
