<?php
declare(strict_types=1);

namespace App\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Doctrine\ORM\EntityManagerInterface;
use Exception;
use Symfony\Component\Console\Exception\LogicException;

/**
 * Class WaitDatabaseCommand
 *
 * @package App\Command\Utils
 */
class WaitDatabaseCommand extends Command
{
    /**
     * Wait sleep time for db connection in seconds
     *
     * @var int
     */
    private const WAIT_SLEEP_TIME = 2;
    private EntityManagerInterface $em;


    /**
     * Constructor
     *
     * @param EntityManagerInterface $em
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
     * @param InputInterface   $input
     * @param OutputInterface $output
     *
     * @return int
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
            } catch (Exception $e) {
                $output->writeln('<comment>Trying to connect to the database seconds:' . $i . '</comment>');
                sleep(self::WAIT_SLEEP_TIME);

                continue;
            }
        }

        $output->writeln('<error>Can not connect to the database</error>');

        return 1;
    }
}
