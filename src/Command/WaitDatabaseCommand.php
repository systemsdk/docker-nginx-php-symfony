<?php

declare(strict_types=1);

namespace App\Command;

use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Exception\LogicException;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Throwable;

/**
 * Class WaitDatabaseCommand
 *
 * @package App\Command\Utils
 */
class WaitDatabaseCommand extends Command
{
    /**
     * Wait sleep time for db connection in seconds
     */
    private const WAIT_SLEEP_TIME = 2;
    private EntityManagerInterface $em;

    /**
     * Constructor
     *
     * @throws LogicException
     */
    public function __construct(EntityManagerInterface $em)
    {
        parent::__construct('db:wait');

        $this->em = $em;
        $this->setDescription('Waits for database availability.')
            ->setHelp('This command allows you to wait for database availability.');
    }

    /**
     * Execute the console command.
     *
     * {@inheritdoc}
     *
     * @phpcsSuppress SlevomatCodingStandard.Functions.UnusedParameter
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        for ($i = 0; $i < 60; $i += self::WAIT_SLEEP_TIME) {
            try {
                $connection = $this->em->getConnection();
                $statement = $connection->prepare('SHOW TABLES');
                $statement->execute();
                $output->writeln('<info>Connection to the database is ok!</info>');

                return 0;
            } catch (Throwable $exception) {
                $output->writeln('<comment>Trying to connect to the database seconds:' . $i . '</comment>');
                sleep(self::WAIT_SLEEP_TIME);

                continue;
            }
        }

        $output->writeln('<error>Can not connect to the database</error>');

        return 1;
    }
}
