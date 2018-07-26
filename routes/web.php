<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Implement your document class
class Viktor implements Finite\StatefulInterface
{
    private $state;

    public function getFiniteState()
    {
        return $this->state;
    }
    public function setFiniteState($state)
    {
        $this->state = $state;
    }
}

Route::get('/', function () {
    return view('welcome');
});

Route::any("test", function () {
    // Configure your graph
    $document     = new Viktor();
    $stateMachine = new Finite\StateMachine\StateMachine($document);
    $loader       = new Finite\Loader\ArrayLoader(array(
        'class'  => 'Document',
        'states'  => array(
            'draft' => array(
                'type'       => Finite\State\StateInterface::TYPE_INITIAL,
                'properties' => array('deletable' => true, 'editable' => true),
            ),
            'proposed' => array(
                'type'       => Finite\State\StateInterface::TYPE_NORMAL,
                'properties' => array(),
            ),
            'accepted' => array(
                'type'       => Finite\State\StateInterface::TYPE_FINAL,
                'properties' => array('printable' => true),
            )
        ),
        'transitions' => array(
            'propose' => array('from' => array('draft'), 'to' => 'proposed'),
            'accept'  => array('from' => array('proposed'), 'to' => 'accepted'),
            'reject'  => array('from' => array('proposed'), 'to' => 'draft'),
        ),
    ));
    $loader->load($stateMachine);
    $stateMachine->initialize();
// Working with workflow
// Current state
    var_dump($stateMachine->getCurrentState()->getName());
    var_dump($stateMachine->getCurrentState()->getProperties());
    var_dump($stateMachine->getCurrentState()->has('deletable'));
    var_dump($stateMachine->getCurrentState()->has('printable'));
// Available transitions
    var_dump($stateMachine->getCurrentState()->getTransitions());
    var_dump($stateMachine->can('propose'));
    var_dump($stateMachine->can('accept'));
// Apply transitions
    try {
        $stateMachine->apply('accept');
    } catch (\Finite\Exception\StateException $e) {
        echo $e->getMessage(), "\n";
    }
// Applying a transition
    $stateMachine->apply('propose');
    var_dump($stateMachine->getCurrentState()->getName());
    var_dump($document->getFiniteState());
});
