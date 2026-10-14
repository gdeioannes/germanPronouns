// Whether the run that just ended won a Ja oder Nein? ticket, for the run
// summary to say so. Set by the quiz page's run handler, cleared on the next.
export const ticketWin = $state({ won: false, tickets: 0 });
